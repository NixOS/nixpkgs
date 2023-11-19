{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.kubo;

  settingsFormat = pkgs.formats.json {};

  rawDefaultConfig = lib.importJSON (pkgs.runCommand "kubo-default-config" {
    nativeBuildInputs = [ cfg.package ];
  } ''
    export IPFS_PATH="$TMPDIR"
    ipfs init --empty-repo --profile=${profile}
    ipfs --offline config show > "$out"
  '');

  # Remove the PeerID (an attribute of "Identity") of the temporary Kubo repo.
  # The "Pinning" section contains the "RemoteServices" section, which would prevent
  # the daemon from starting as that setting can't be changed via ipfs config replace.
  defaultConfig = builtins.removeAttrs rawDefaultConfig [ "Identity" "Pinning" ];

  customizedConfig = lib.recursiveUpdate defaultConfig cfg.settings;

  configFile = settingsFormat.generate "kubo-config.json" customizedConfig;

  # Create a fake repo containing only the file "api".
  # $IPFS_PATH will point to this directory instead of the real one.
  # For some reason the Kubo CLI tools insist on reading the
  # config file when it exists. But the Kubo daemon sets the file
  # permissions such that only the ipfs user is allowed to read
  # this file. This prevents normal users from talking to the daemon.
  # To work around this terrible design, create a fake repo with no
  # config file, only an api file and everything should work as expected.
  fakeKuboRepo = pkgs.writeTextDir "api" ''
    /unix/run/ipfs.sock
  '';

  kuboFlags = utils.escapeSystemdExecArgs (
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

  multiaddrsToListenStreams = addrIn:
    let
      addrs = if builtins.typeOf addrIn == "list"
      then addrIn else [ addrIn ];
      unfilteredResult = map multiaddrToListenStream addrs;
    in
      builtins.filter (addr: addr != null) unfilteredResult;

  multiaddrsToListenDatagrams = addrIn:
    let
      addrs = if builtins.typeOf addrIn == "list"
      then addrIn else [ addrIn ];
      unfilteredResult = map multiaddrToListenDatagram addrs;
    in
      builtins.filter (addr: addr != null) unfilteredResult;

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

    services.kubo = {

      enable = mkEnableOption (lib.mdDoc "Interplanetary File System (WARNING: may cause severe network degradation)");

      package = mkOption {
        type = types.package;
        default = pkgs.kubo;
        defaultText = literalExpression "pkgs.kubo";
        description = lib.mdDoc "Which Kubo package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = lib.mdDoc "User under which the Kubo daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = lib.mdDoc "Group under which the Kubo daemon runs";
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
        description = lib.mdDoc "The data dir for Kubo";
      };

      defaultMode = mkOption {
        type = types.enum [ "online" "offline" "norouting" ];
        default = "online";
        description = lib.mdDoc "systemd service that is enabled by default";
      };

      autoMount = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether Kubo should try to mount /ipfs and /ipns at startup.";
      };

      autoMigrate = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether Kubo should try to run the fs-repo-migration at startup.";
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

      enableGC = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable automatic garbage collection";
      };

      emptyRepo = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "If set to false, the repo will be initialized with help files";
      };

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            Addresses.API = mkOption {
              type = types.oneOf [ types.str (types.listOf types.str) ];
              default = [ ];
              description = lib.mdDoc ''
                Multiaddr or array of multiaddrs describing the address to serve the local HTTP API on.
                In addition to the multiaddrs listed here, the daemon will also listen on a Unix domain socket.
                To allow the ipfs CLI tools to communicate with the daemon over that socket,
                add your user to the correct group, e.g. `users.users.alice.extraGroups = [ config.services.kubo.group ];`
              '';
            };

            Addresses.Gateway = mkOption {
              type = types.oneOf [ types.str (types.listOf types.str) ];
              default = "/ip4/127.0.0.1/tcp/8080";
              description = lib.mdDoc "Where the IPFS Gateway can be reached";
            };

            Addresses.Swarm = mkOption {
              type = types.listOf types.str;
              default = [
                "/ip4/0.0.0.0/tcp/4001"
                "/ip6/::/tcp/4001"
                "/ip4/0.0.0.0/udp/4001/quic-v1"
                "/ip4/0.0.0.0/udp/4001/quic-v1/webtransport"
                "/ip6/::/udp/4001/quic-v1"
                "/ip6/::/udp/4001/quic-v1/webtransport"
              ];
              description = lib.mdDoc "Where Kubo listens for incoming p2p connections";
            };
          };
        };
        description = lib.mdDoc ''
          Attrset of daemon configuration.
          See [https://github.com/ipfs/kubo/blob/master/docs/config.md](https://github.com/ipfs/kubo/blob/master/docs/config.md) for reference.
          You can't set `Identity` or `Pinning`.
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
        description = lib.mdDoc "Extra flags passed to the Kubo daemon";
        default = [ ];
      };

      localDiscovery = mkOption {
        type = types.bool;
        description = lib.mdDoc ''Whether to enable local discovery for the Kubo daemon.
          This will allow Kubo to scan ports on your local network. Some hosting services will ban you if you do this.
        '';
        default = false;
      };

      serviceFdlimit = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc "The fdlimit for the Kubo systemd unit or `null` to have the daemon attempt to manage it";
        example = 64 * 1024;
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to use socket activation to start Kubo when needed.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !builtins.hasAttr "Identity" cfg.settings;
        message = ''
          You can't set services.kubo.settings.Identity because the ``config replace`` subcommand used at startup does not support modifying any of the Identity settings.
        '';
      }
      {
        assertion = !((builtins.hasAttr "Pinning" cfg.settings) && (builtins.hasAttr "RemoteServices" cfg.settings.Pinning));
        message = ''
          You can't set services.kubo.settings.Pinning.RemoteServices because the ``config replace`` subcommand used at startup does not work with it.
        '';
      }
      {
        assertion = !((lib.versionAtLeast cfg.package.version "0.21") && (builtins.hasAttr "Experimental" cfg.settings) && (builtins.hasAttr "AcceleratedDHTClient" cfg.settings.Experimental));
        message = ''
    The `services.kubo.settings.Experimental.AcceleratedDHTClient` option was renamed to `services.kubo.settings.Routing.AcceleratedDHTClient` in Kubo 0.21.
  '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
    environment.variables.IPFS_PATH = fakeKuboRepo;

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
          pkgs.kubo-migrator
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

    services.kubo.settings = mkIf cfg.autoMount {
      Mounts.FuseAllowOther = lib.mkDefault true;
      Mounts.IPFS = lib.mkDefault cfg.ipfsMountDir;
      Mounts.IPNS = lib.mkDefault cfg.ipnsMountDir;
    };

    systemd.services.ipfs = {
      path = [ "/run/wrappers" cfg.package ];
      environment.IPFS_PATH = cfg.dataDir;

      preStart = ''
        if [[ ! -f "$IPFS_PATH/config" ]]; then
          ipfs init --empty-repo=${lib.boolToString cfg.emptyRepo}
        else
          # After an unclean shutdown this file may exist which will cause the config command to attempt to talk to the daemon. This will hang forever if systemd is holding our sockets open.
          rm -vf "$IPFS_PATH/api"
      '' + optionalString cfg.autoMigrate ''
        ${pkgs.kubo-migrator}/bin/fs-repo-migrations -to '${cfg.package.repoVersion}' -y
      '' + ''
        fi
        ipfs --offline config show |
          ${pkgs.jq}/bin/jq -s '.[0].Pinning as $Pinning | .[0].Identity as $Identity | .[1] + {$Identity,$Pinning}' - '${configFile}' |

          # This command automatically injects the private key and other secrets from
          # the old config file back into the new config file.
          # Unfortunately, it doesn't keep the original `Identity.PeerID`,
          # so we need `ipfs config show` and jq above.
          # See https://github.com/ipfs/kubo/issues/8993 for progress on fixing this problem.
          # Kubo also wants a specific version of the original "Pinning.RemoteServices"
          # section (redacted by `ipfs config show`), such that that section doesn't
          # change when the changes are applied. Whyyyyyy.....
          ipfs --offline config replace -
      '';
      postStop = mkIf cfg.autoMount ''
        # After an unclean shutdown the fuse mounts at cfg.ipnsMountDir and cfg.ipfsMountDir are locked
        umount --quiet '${cfg.ipnsMountDir}' '${cfg.ipfsMountDir}' || true
      '';
      serviceConfig = {
        ExecStart = [ "" "${cfg.package}/bin/ipfs daemon ${kuboFlags}" ];
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
          [ "" ] ++ (multiaddrsToListenStreams cfg.settings.Addresses.Gateway);
        ListenDatagram =
          [ "" ] ++ (multiaddrsToListenDatagrams cfg.settings.Addresses.Gateway);
      };
    };

    systemd.sockets.ipfs-api = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        # We also include "%t/ipfs.sock" because there is no way to put the "%t"
        # in the multiaddr.
        ListenStream =
          [ "" "%t/ipfs.sock" ] ++ (multiaddrsToListenStreams cfg.settings.Addresses.API);
        SocketMode = "0660";
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Luflosi ];
  };

  imports = [
    (mkRenamedOptionModule [ "services" "ipfs" "enable" ] [ "services" "kubo" "enable" ])
    (mkRenamedOptionModule [ "services" "ipfs" "package" ] [ "services" "kubo" "package" ])
    (mkRenamedOptionModule [ "services" "ipfs" "user" ] [ "services" "kubo" "user" ])
    (mkRenamedOptionModule [ "services" "ipfs" "group" ] [ "services" "kubo" "group" ])
    (mkRenamedOptionModule [ "services" "ipfs" "dataDir" ] [ "services" "kubo" "dataDir" ])
    (mkRenamedOptionModule [ "services" "ipfs" "defaultMode" ] [ "services" "kubo" "defaultMode" ])
    (mkRenamedOptionModule [ "services" "ipfs" "autoMount" ] [ "services" "kubo" "autoMount" ])
    (mkRenamedOptionModule [ "services" "ipfs" "autoMigrate" ] [ "services" "kubo" "autoMigrate" ])
    (mkRenamedOptionModule [ "services" "ipfs" "ipfsMountDir" ] [ "services" "kubo" "ipfsMountDir" ])
    (mkRenamedOptionModule [ "services" "ipfs" "ipnsMountDir" ] [ "services" "kubo" "ipnsMountDir" ])
    (mkRenamedOptionModule [ "services" "ipfs" "gatewayAddress" ] [ "services" "kubo" "settings" "Addresses" "Gateway" ])
    (mkRenamedOptionModule [ "services" "ipfs" "apiAddress" ] [ "services" "kubo" "settings" "Addresses" "API" ])
    (mkRenamedOptionModule [ "services" "ipfs" "swarmAddress" ] [ "services" "kubo" "settings" "Addresses" "Swarm" ])
    (mkRenamedOptionModule [ "services" "ipfs" "enableGC" ] [ "services" "kubo" "enableGC" ])
    (mkRenamedOptionModule [ "services" "ipfs" "emptyRepo" ] [ "services" "kubo" "emptyRepo" ])
    (mkRenamedOptionModule [ "services" "ipfs" "extraConfig" ] [ "services" "kubo" "settings" ])
    (mkRenamedOptionModule [ "services" "ipfs" "extraFlags" ] [ "services" "kubo" "extraFlags" ])
    (mkRenamedOptionModule [ "services" "ipfs" "localDiscovery" ] [ "services" "kubo" "localDiscovery" ])
    (mkRenamedOptionModule [ "services" "ipfs" "serviceFdlimit" ] [ "services" "kubo" "serviceFdlimit" ])
    (mkRenamedOptionModule [ "services" "ipfs" "startWhenNeeded" ] [ "services" "kubo" "startWhenNeeded" ])
    (mkRenamedOptionModule [ "services" "kubo" "extraConfig" ] [ "services" "kubo" "settings" ])
    (mkRenamedOptionModule [ "services" "kubo" "gatewayAddress" ] [ "services" "kubo" "settings" "Addresses" "Gateway" ])
    (mkRenamedOptionModule [ "services" "kubo" "apiAddress" ] [ "services" "kubo" "settings" "Addresses" "API" ])
    (mkRenamedOptionModule [ "services" "kubo" "swarmAddress" ] [ "services" "kubo" "settings" "Addresses" "Swarm" ])
  ];
}
