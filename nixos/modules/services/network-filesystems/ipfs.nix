{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.ipfs;

  ipfsFlags = utils.escapeSystemdExecArgs (
    optional cfg.autoMount "--mount" ++
    optional cfg.enableGC "--enable-gc" ++
    optional (cfg.serviceFdlimit != null) "--manage-fdlimit=false" ++
    optional (cfg.defaultMode == "offline") "--offline" ++
    optional (cfg.defaultMode == "norouting") "--routing=none" ++
    cfg.extraFlags
  );

  profile =
    if cfg.localDiscovery
    then "local-discovery"
    else "server";

  splitMulitaddr = addrRaw: lib.tail (lib.splitString "/" addrRaw);

  multiaddrToListenStream = addrRaw:
    let
      addr = splitMulitaddr addrRaw;
      s = builtins.elemAt addr;
    in
    if s 0 == "ip4" && s 2 == "tcp"
    then "${s 1}:${s 3}"
    else if s 0 == "ip6" && s 2 == "tcp"
    then "[${s 1}]:${s 3}"
    else if s 0 == "unix"
    then "/${lib.concatStringsSep "/" (lib.tail addr)}"
    else null; # not valid for listen stream, skip

  multiaddrToListenDatagram = addrRaw:
    let
      addr = splitMulitaddr addrRaw;
      s = builtins.elemAt addr;
    in
    if s 0 == "ip4" && s 2 == "udp"
    then "${s 1}:${s 3}"
    else if s 0 == "ip6" && s 2 == "udp"
    then "[${s 1}]:${s 3}"
    else null; # not valid for listen datagram, skip

in
{

  ###### interface

  options = {

    services.ipfs = {

      enable = mkEnableOption (lib.mdDoc "Interplanetary File System (WARNING: may cause severe network degredation)");

      package = mkOption {
        type = types.package;
        default = pkgs.ipfs;
        defaultText = literalExpression "pkgs.ipfs";
        description = lib.mdDoc "Which IPFS package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = lib.mdDoc "User under which the IPFS daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = lib.mdDoc "Group under which the IPFS daemon runs";
      };

      dataDir = mkOption {
        type = types.str;
        default =
          if versionAtLeast config.system.stateVersion "17.09"
          then "/var/lib/ipfs"
          else "/var/lib/ipfs/.ipfs";
        defaultText = literalExpression ''
          if versionAtLeast config.system.stateVersion "17.09"
          then "/var/lib/ipfs"
          else "/var/lib/ipfs/.ipfs"
        '';
        description = lib.mdDoc "The data dir for IPFS";
      };

      defaultMode = mkOption {
        type = types.enum [ "online" "offline" "norouting" ];
        default = "online";
        description = lib.mdDoc "systemd service that is enabled by default";
      };

      autoMount = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether IPFS should try to mount /ipfs and /ipns at startup.";
      };

      autoMigrate = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether IPFS should try to run the fs-repo-migration at startup.";
      };

      ipfsMountDir = mkOption {
        type = types.str;
        default = "/ipfs";
        description = lib.mdDoc "Where to mount the IPFS namespace to";
      };

      ipnsMountDir = mkOption {
        type = types.str;
        default = "/ipns";
        description = lib.mdDoc "Where to mount the IPNS namespace to";
      };

      gatewayAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/8080";
        description = lib.mdDoc "Where the IPFS Gateway can be reached";
      };

      apiAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/5001";
        description = lib.mdDoc "Where IPFS exposes its API to";
      };

      swarmAddress = mkOption {
        type = types.listOf types.str;
        default = [
          "/ip4/0.0.0.0/tcp/4001"
          "/ip6/::/tcp/4001"
          "/ip4/0.0.0.0/udp/4001/quic"
          "/ip6/::/udp/4001/quic"
        ];
        description = lib.mdDoc "Where IPFS listens for incoming p2p connections";
      };

      enableGC = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable automatic garbage collection";
      };

      emptyRepo = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "If set to true, the repo won't be initialized with help files";
      };

      extraConfig = mkOption {
        type = types.attrs;
        description = lib.mdDoc ''
          Attrset of daemon configuration to set using {command}`ipfs config`, every time the daemon starts.
          These are applied last, so may override configuration set by other options in this module.
          Keep in mind that this configuration is stateful; i.e., unsetting anything in here does not reset the value to the default!
        '';
        default = { };
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
        description = lib.mdDoc "Extra flags passed to the IPFS daemon";
        default = [ ];
      };

      localDiscovery = mkOption {
        type = types.bool;
        description = lib.mdDoc ''Whether to enable local discovery for the ipfs daemon.
          This will allow ipfs to scan ports on your local network. Some hosting services will ban you if you do this.
        '';
        default = false;
      };

      serviceFdlimit = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc "The fdlimit for the IPFS systemd unit or `null` to have the daemon attempt to manage it";
        example = 64 * 1024;
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to use socket activation to start IPFS when needed.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.variables.IPFS_PATH = cfg.dataDir;

    # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size
    boot.kernel.sysctl."net.core.rmem_max" = mkDefault 2500000;

    programs.fuse = mkIf cfg.autoMount {
      userAllowOther = true;
    };

    users.users = mkIf (cfg.user == "ipfs") {
      ipfs = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = false;
        uid = config.ids.uids.ipfs;
        description = "IPFS daemon user";
        packages = [
          pkgs.ipfs-migrator
        ];
      };
    };

    users.groups = mkIf (cfg.group == "ipfs") {
      ipfs.gid = config.ids.gids.ipfs;
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ] ++ optionals cfg.autoMount [
      "d '${cfg.ipfsMountDir}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.ipnsMountDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    # The hardened systemd unit breaks the fuse-mount function according to documentation in the unit file itself
    systemd.packages = if cfg.autoMount
      then [ cfg.package.systemd_unit ]
      else [ cfg.package.systemd_unit_hardened ];

    systemd.services.ipfs = {
      path = [ "/run/wrappers" cfg.package ];
      environment.IPFS_PATH = cfg.dataDir;

      preStart = ''
        if [[ ! -f "$IPFS_PATH/config" ]]; then
          ipfs init ${optionalString cfg.emptyRepo "-e"} --profile=${profile}
        else
          # After an unclean shutdown this file may exist which will cause the config command to attempt to talk to the daemon. This will hang forever if systemd is holding our sockets open.
          rm -vf "$IPFS_PATH/api"
      '' + optionalString cfg.autoMigrate ''
        ${pkgs.ipfs-migrator}/bin/fs-repo-migrations -to '${cfg.package.repoVersion}' -y
      '' + ''
          ipfs --offline config profile apply ${profile} >/dev/null
        fi
      '' + optionalString cfg.autoMount ''
        ipfs --offline config Mounts.FuseAllowOther --json true
        ipfs --offline config Mounts.IPFS ${cfg.ipfsMountDir}
        ipfs --offline config Mounts.IPNS ${cfg.ipnsMountDir}
      '' + ''
        ipfs --offline config show \
          | ${pkgs.jq}/bin/jq '. * $extraConfig' --argjson extraConfig ${
              escapeShellArg (builtins.toJSON (
                recursiveUpdate
                  {
                    Addresses.API = cfg.apiAddress;
                    Addresses.Gateway = cfg.gatewayAddress;
                    Addresses.Swarm = cfg.swarmAddress;
                  }
                  cfg.extraConfig
              ))
            } \
          | ipfs --offline config replace -
      '';
      serviceConfig = {
        ExecStart = [ "" "${cfg.package}/bin/ipfs daemon ${ipfsFlags}" ];
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "";
        ReadWritePaths = optionals (!cfg.autoMount) [ "" cfg.dataDir ];
      } // optionalAttrs (cfg.serviceFdlimit != null) { LimitNOFILE = cfg.serviceFdlimit; };
    } // optionalAttrs (!cfg.startWhenNeeded) {
      wantedBy = [ "default.target" ];
    };

    systemd.sockets.ipfs-gateway = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream =
          let
            fromCfg = multiaddrToListenStream cfg.gatewayAddress;
          in
          [ "" ] ++ lib.optional (fromCfg != null) fromCfg;
        ListenDatagram =
          let
            fromCfg = multiaddrToListenDatagram cfg.gatewayAddress;
          in
          [ "" ] ++ lib.optional (fromCfg != null) fromCfg;
      };
    };

    systemd.sockets.ipfs-api = {
      wantedBy = [ "sockets.target" ];
      # We also include "%t/ipfs.sock" because there is no way to put the "%t"
      # in the multiaddr.
      socketConfig.ListenStream =
        let
          fromCfg = multiaddrToListenStream cfg.apiAddress;
        in
        [ "" "%t/ipfs.sock" ] ++ lib.optional (fromCfg != null) fromCfg;
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
