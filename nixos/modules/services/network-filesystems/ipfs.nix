{ config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs) ipfs runCommand makeWrapper;

  cfg = config.services.ipfs;

  ipfsFlags = toString ([
    (optionalString  cfg.autoMount                   "--mount")
    #(optionalString  cfg.autoMigrate                 "--migrate")
    (optionalString  cfg.enableGC                    "--enable-gc")
    (optionalString (cfg.serviceFdlimit != null)     "--manage-fdlimit=false")
    (optionalString (cfg.defaultMode == "offline")   "--offline")
    (optionalString (cfg.defaultMode == "norouting") "--routing=none")
  ] ++ cfg.extraFlags);

  defaultDataDir = if versionAtLeast config.system.stateVersion "17.09" then
    "/var/lib/ipfs" else
    "/var/lib/ipfs/.ipfs";

  # Wrapping the ipfs binary with the environment variable IPFS_PATH set to dataDir because we can't set it in the user environment
  wrapped = runCommand "ipfs" { buildInputs = [ makeWrapper ]; preferLocalBuild = true; } ''
    mkdir -p "$out/bin"
    makeWrapper "${ipfs}/bin/ipfs" "$out/bin/ipfs" \
      --set IPFS_PATH ${cfg.dataDir} \
      --prefix PATH : /run/wrappers/bin
  '';


  commonEnv = {
    environment.IPFS_PATH = cfg.dataDir;
    path = [ wrapped ];
    serviceConfig.User = cfg.user;
    serviceConfig.Group = cfg.group;
  };

  baseService = recursiveUpdate commonEnv {
    wants = [ "ipfs-init.service" ];
    # NB: migration must be performed prior to pre-start, else we get the failure message!
    preStart = ''
      ipfs repo fsck # workaround for BUG #4212 (https://github.com/ipfs/go-ipfs/issues/4214)
    '' + optionalString cfg.autoMount ''
      ipfs --local config Mounts.FuseAllowOther --json true
      ipfs --local config Mounts.IPFS ${cfg.ipfsMountDir}
      ipfs --local config Mounts.IPNS ${cfg.ipnsMountDir}
    '' + concatStringsSep "\n" (collect
          isString
          (mapAttrsRecursive
            (path: value:
            # Using heredoc below so that the value is never improperly quoted
            ''
              read value <<EOF
              ${builtins.toJSON value}
              EOF
              ipfs --local config --json "${concatStringsSep "." path}" "$value"
            '')
            ({ Addresses.API = cfg.apiAddress;
               Addresses.Gateway = cfg.gatewayAddress;
               Addresses.Swarm = cfg.swarmAddress;
            } //
            cfg.extraConfig))
        );
    serviceConfig = {
      ExecStart = "${wrapped}/bin/ipfs daemon ${ipfsFlags}";
      Restart = "on-failure";
      RestartSec = 1;
    } // optionalAttrs (cfg.serviceFdlimit != null) { LimitNOFILE = cfg.serviceFdlimit; };
  };
in {

  ###### interface

  options = {

    services.ipfs = {

      enable = mkEnableOption "Interplanetary File System (WARNING: may cause severe network degredation)";

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = "User under which the IPFS daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = "Group under which the IPFS daemon runs";
      };

      dataDir = mkOption {
        type = types.str;
        default = defaultDataDir;
        description = "The data dir for IPFS";
      };

      defaultMode = mkOption {
        type = types.enum [ "online" "offline" "norouting" ];
        default = "online";
        description = "systemd service that is enabled by default";
      };

      /*
      autoMigrate = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether IPFS should try to migrate the file system automatically.

          The daemon will need to be able to download a binary from https://ipfs.io to perform the migration.
        '';
      };
      */

      autoMount = mkOption {
        type = types.bool;
        default = false;
        description = "Whether IPFS should try to mount /ipfs and /ipns at startup.";
      };

      ipfsMountDir = mkOption {
        type = types.str;
        default = "/ipfs";
        description = "Where to mount the IPFS namespace to";
      };

      ipnsMountDir = mkOption {
        type = types.str;
        default = "/ipns";
        description = "Where to mount the IPNS namespace to";
      };

      gatewayAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/8080";
        description = "Where the IPFS Gateway can be reached";
      };

      apiAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/5001";
        description = "Where IPFS exposes its API to";
      };

      swarmAddress = mkOption {
        type = types.listOf types.str;
        default = [ "/ip4/0.0.0.0/tcp/4001" "/ip6/::/tcp/4001" ];
        description = "Where IPFS listens for incoming p2p connections";
      };

      enableGC = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable automatic garbage collection";
      };

      emptyRepo = mkOption {
        type = types.bool;
        default = false;
        description = "If set to true, the repo won't be initialized with help files";
      };

      extraConfig = mkOption {
        type = types.attrs;
        description = ''
          Attrset of daemon configuration to set using <command>ipfs config</command>, every time the daemon starts.
          These are applied last, so may override configuration set by other options in this module.
          Keep in mind that this configuration is stateful; i.e., unsetting anything in here does not reset the value to the default!
        '';
        default = {};
        example = {
          Datastore.StorageMax = "100GB";
          Discovery.MDNS.Enabled = false;
          Bootstrap = [
            "/ip4/128.199.219.111/tcp/4001/ipfs/QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu"
            "/ip4/162.243.248.213/tcp/4001/ipfs/QmSoLueR4xBeUbY9WZ9xGUUxunbKWcrNFTDAadQJmocnWm"
          ];
          Swarm.AddrFilters = null;
        };

      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the IPFS daemon";
        default = [];
      };

      localDiscovery = mkOption {
        type = types.bool;
        description = ''Whether to enable local discovery for the ipfs daemon.
          This will allow ipfs to scan ports on your local network. Some hosting services will ban you if you do this.
        '';
        default = true;
      };

      serviceFdlimit = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "The fdlimit for the IPFS systemd unit or <literal>null</literal> to have the daemon attempt to manage it";
        example = 64*1024;
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ wrapped ];
    environment.etc."fuse.conf" = mkIf cfg.autoMount { text = ''
      user_allow_other
    ''; };

    users.users = mkIf (cfg.user == "ipfs") {
      ipfs = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = false;
        uid = config.ids.uids.ipfs;
        description = "IPFS daemon user";
      };
    };

    users.groups = mkIf (cfg.group == "ipfs") {
      ipfs.gid = config.ids.gids.ipfs;
    };

    systemd.services.ipfs-init = recursiveUpdate commonEnv {
      description = "IPFS Initializer";

      after = [ "local-fs.target" ];
      before = [ "ipfs.service" "ipfs-offline.service" "ipfs-norouting.service" ];

      preStart = ''
        install -m 0755 -o ${cfg.user} -g ${cfg.group} -d ${cfg.dataDir}
      '' + optionalString cfg.autoMount ''
        install -m 0755 -o ${cfg.user} -g ${cfg.group} -d ${cfg.ipfsMountDir}
        install -m 0755 -o ${cfg.user} -g ${cfg.group} -d ${cfg.ipnsMountDir}
      '';
      script = ''
        if [[ ! -f ${cfg.dataDir}/config ]]; then
          ipfs init ${optionalString cfg.emptyRepo "-e"} \
            ${optionalString (! cfg.localDiscovery) "--profile=server"}
        else
          ${if cfg.localDiscovery
            then "ipfs config profile apply local-discovery"
            else "ipfs config profile apply server"
          }
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        PermissionsStartOnly = true;
      };
    };

    # TODO These 3 definitions possibly be further abstracted through use of a function
    # like: mutexServices "ipfs" [ "", "offline", "norouting" ] { ... shared conf here ... }

    systemd.services.ipfs = recursiveUpdate baseService {
      description = "IPFS Daemon";
      wantedBy = mkIf (cfg.defaultMode == "online") [ "multi-user.target" ];
      after = [ "network.target" "local-fs.target" "ipfs-init.service" ];
      conflicts = [ "ipfs-offline.service" "ipfs-norouting.service"];
    };

    systemd.services.ipfs-offline = recursiveUpdate baseService {
      description = "IPFS Daemon (offline mode)";
      wantedBy = mkIf (cfg.defaultMode == "offline") [ "multi-user.target" ];
      after = [ "local-fs.target" "ipfs-init.service" ];
      conflicts = [ "ipfs.service" "ipfs-norouting.service"];
    };

    systemd.services.ipfs-norouting = recursiveUpdate baseService {
      description = "IPFS Daemon (no routing mode)";
      wantedBy = mkIf (cfg.defaultMode == "norouting") [ "multi-user.target" ];
      after = [ "local-fs.target" "ipfs-init.service" ];
      conflicts = [ "ipfs.service" "ipfs-offline.service"];
    };

  };
}
