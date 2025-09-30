{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.kubo;

  settingsFormat = pkgs.formats.json { };

  rawDefaultConfig = lib.importJSON (
    pkgs.runCommand "kubo-default-config"
      {
        nativeBuildInputs = [ cfg.package ];
      }
      ''
        export IPFS_PATH="$TMPDIR"
        ipfs init --empty-repo --profile=${profile}
        ipfs --offline config show > "$out"
      ''
  );

  # Remove the PeerID (an attribute of "Identity") of the temporary Kubo repo.
  # The "Pinning" section contains the "RemoteServices" section, which would prevent
  # the daemon from starting as that setting can't be changed via ipfs config replace.
  defaultConfig = builtins.removeAttrs rawDefaultConfig [
    "Identity"
    "Pinning"
  ];

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
    lib.optional cfg.autoMount "--mount"
    ++ lib.optional cfg.enableGC "--enable-gc"
    ++ lib.optional (cfg.serviceFdlimit != null) "--manage-fdlimit=false"
    ++ lib.optional (cfg.defaultMode == "offline") "--offline"
    ++ lib.optional (cfg.defaultMode == "norouting") "--routing=none"
    ++ cfg.extraFlags
  );

  profile = if cfg.localDiscovery then "local-discovery" else "server";

  splitMulitaddr = addrRaw: lib.tail (lib.splitString "/" addrRaw);

  multiaddrsToListenStreams =
    addrIn:
    let
      addrs = if builtins.isList addrIn then addrIn else [ addrIn ];
      unfilteredResult = map multiaddrToListenStream addrs;
    in
    builtins.filter (addr: addr != null) unfilteredResult;

  multiaddrsToListenDatagrams =
    addrIn:
    let
      addrs = if builtins.isList addrIn then addrIn else [ addrIn ];
      unfilteredResult = map multiaddrToListenDatagram addrs;
    in
    builtins.filter (addr: addr != null) unfilteredResult;

  multiaddrToListenStream =
    addrRaw:
    let
      addr = splitMulitaddr addrRaw;
      s = builtins.elemAt addr;
    in
    if s 0 == "ip4" && s 2 == "tcp" then
      "${s 1}:${s 3}"
    else if s 0 == "ip6" && s 2 == "tcp" then
      "[${s 1}]:${s 3}"
    else if s 0 == "unix" then
      "/${lib.concatStringsSep "/" (lib.tail addr)}"
    else
      null; # not valid for listen stream, skip

  multiaddrToListenDatagram =
    addrRaw:
    let
      addr = splitMulitaddr addrRaw;
      s = builtins.elemAt addr;
    in
    if s 0 == "ip4" && s 2 == "udp" then
      "${s 1}:${s 3}"
    else if s 0 == "ip6" && s 2 == "udp" then
      "[${s 1}]:${s 3}"
    else
      null; # not valid for listen datagram, skip

in
{

  ###### interface

  options = {

    services.kubo = {

      enable = lib.mkEnableOption ''
        the Interplanetary File System (WARNING: may cause severe network degradation).
        NOTE: after enabling this option and rebuilding your system, you need to log out
        and back in for the `IPFS_PATH` environment variable to be present in your shell.
        Until you do that, the CLI tools won't be able to talk to the daemon by default
      '';

      package = lib.mkPackageOption pkgs "kubo" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ipfs";
        description = "User under which the Kubo daemon runs";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "ipfs";
        description = "Group under which the Kubo daemon runs";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default =
          if lib.versionAtLeast config.system.stateVersion "17.09" then
            "/var/lib/ipfs"
          else
            "/var/lib/ipfs/.ipfs";
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast config.system.stateVersion "17.09"
          then "/var/lib/ipfs"
          else "/var/lib/ipfs/.ipfs"
        '';
        description = "The data dir for Kubo";
      };

      defaultMode = lib.mkOption {
        type = lib.types.enum [
          "online"
          "offline"
          "norouting"
        ];
        default = "online";
        description = "systemd service that is enabled by default";
      };

      autoMount = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Kubo should try to mount /ipfs, /ipns and /mfs at startup.";
      };

      autoMigrate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether Kubo should try to run the fs-repo-migration at startup.";
      };

      enableGC = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable automatic garbage collection";
      };

      emptyRepo = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "If set to false, the repo will be initialized with help files";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            Addresses.API = lib.mkOption {
              type = lib.types.oneOf [
                lib.types.str
                (lib.types.listOf lib.types.str)
              ];
              default = [ ];
              description = ''
                Multiaddr or array of multiaddrs describing the address to serve the local HTTP API on.
                In addition to the multiaddrs listed here, the daemon will also listen on a Unix domain socket.
                To allow the ipfs CLI tools to communicate with the daemon over that socket,
                add your user to the correct group, e.g. `users.users.alice.extraGroups = [ config.services.kubo.group ];`
              '';
            };

            Addresses.Gateway = lib.mkOption {
              type = lib.types.oneOf [
                lib.types.str
                (lib.types.listOf lib.types.str)
              ];
              default = "/ip4/127.0.0.1/tcp/8080";
              description = "Where the IPFS Gateway can be reached";
            };

            Addresses.Swarm = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "/ip4/0.0.0.0/tcp/4001"
                "/ip6/::/tcp/4001"
                "/ip4/0.0.0.0/udp/4001/quic-v1"
                "/ip4/0.0.0.0/udp/4001/quic-v1/webtransport"
                "/ip4/0.0.0.0/udp/4001/webrtc-direct"
                "/ip6/::/udp/4001/quic-v1"
                "/ip6/::/udp/4001/quic-v1/webtransport"
                "/ip6/::/udp/4001/webrtc-direct"
              ];
              description = "Where Kubo listens for incoming p2p connections";
            };

            Mounts.IPFS = lib.mkOption {
              type = lib.types.str;
              default = "/ipfs";
              description = "Where to mount the IPFS namespace to";
            };

            Mounts.IPNS = lib.mkOption {
              type = lib.types.str;
              default = "/ipns";
              description = "Where to mount the IPNS namespace to";
            };

            Mounts.MFS = lib.mkOption {
              type = lib.types.str;
              default = "/mfs";
              description = "Where to mount the MFS namespace to";
            };
          };
        };
        description = ''
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

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Extra flags passed to the Kubo daemon";
        default = [ ];
      };

      localDiscovery = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to enable local discovery for the Kubo daemon.
                    This will allow Kubo to scan ports on your local network. Some hosting services will ban you if you do this.
        '';
        default = false;
      };

      serviceFdlimit = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "The fdlimit for the Kubo systemd unit or `null` to have the daemon attempt to manage it";
        example = 64 * 1024;
      };

      startWhenNeeded = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use socket activation to start Kubo when needed.";
      };

    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !builtins.hasAttr "Identity" cfg.settings;
        message = ''
          You can't set services.kubo.settings.Identity because the ``config replace`` subcommand used at startup does not support modifying any of the Identity settings.
        '';
      }
      {
        assertion =
          !(
            (builtins.hasAttr "Pinning" cfg.settings)
            && (builtins.hasAttr "RemoteServices" cfg.settings.Pinning)
          );
        message = ''
          You can't set services.kubo.settings.Pinning.RemoteServices because the ``config replace`` subcommand used at startup does not work with it.
        '';
      }
      {
        assertion =
          !(
            (lib.versionAtLeast cfg.package.version "0.21")
            && (builtins.hasAttr "Experimental" cfg.settings)
            && (builtins.hasAttr "AcceleratedDHTClient" cfg.settings.Experimental)
          );
        message = ''
          The `services.kubo.settings.Experimental.AcceleratedDHTClient` option was renamed to `services.kubo.settings.Routing.AcceleratedDHTClient` in Kubo 0.21.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
    environment.variables.IPFS_PATH = fakeKuboRepo;

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    boot.kernel.sysctl."net.core.rmem_max" = lib.mkDefault 2500000;
    boot.kernel.sysctl."net.core.wmem_max" = lib.mkDefault 2500000;

    programs.fuse = lib.mkIf cfg.autoMount {
      userAllowOther = true;
    };

    users.users = lib.mkIf (cfg.user == "ipfs") {
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

    users.groups = lib.mkIf (cfg.group == "ipfs") {
      ipfs.gid = config.ids.gids.ipfs;
    };

    systemd.tmpfiles.settings."10-kubo" =
      let
        defaultConfig = { inherit (cfg) user group; };
      in
      {
        ${cfg.dataDir}.d = defaultConfig;
        ${cfg.settings.Mounts.IPFS}.d = lib.mkIf (cfg.autoMount) defaultConfig;
        ${cfg.settings.Mounts.IPNS}.d = lib.mkIf (cfg.autoMount) defaultConfig;
        ${cfg.settings.Mounts.MFS}.d = lib.mkIf (cfg.autoMount) defaultConfig;
      };

    # The hardened systemd unit breaks the fuse-mount function according to documentation in the unit file itself
    systemd.packages =
      if cfg.autoMount then [ cfg.package.systemd_unit ] else [ cfg.package.systemd_unit_hardened ];

    services.kubo.settings = lib.mkIf cfg.autoMount {
      Mounts.FuseAllowOther = lib.mkDefault true;
    };

    systemd.services.ipfs = {
      path = [
        "/run/wrappers"
        cfg.package
      ];
      environment.IPFS_PATH = cfg.dataDir;

      preStart = ''
        if [[ ! -f "$IPFS_PATH/config" ]]; then
          ipfs init --empty-repo=${lib.boolToString cfg.emptyRepo}
        else
          # After an unclean shutdown this file may exist which will cause the config command to attempt to talk to the daemon. This will hang forever if systemd is holding our sockets open.
          rm -vf "$IPFS_PATH/api"
      ''
      + lib.optionalString cfg.autoMigrate ''
        '${lib.getExe pkgs.kubo-migrator}' -to '${cfg.package.repoVersion}' -y
      ''
      + ''
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
      postStop = lib.mkIf cfg.autoMount ''
        # After an unclean shutdown the fuse mounts at cfg.settings.Mounts.IPFS, cfg.settings.Mounts.IPNS and cfg.settings.Mounts.MFS are locked
        umount --quiet '${cfg.settings.Mounts.IPFS}' '${cfg.settings.Mounts.IPNS}' '${cfg.settings.Mounts.MFS}' || true
      '';
      serviceConfig = {
        ExecStart = [
          ""
          "${cfg.package}/bin/ipfs daemon ${kuboFlags}"
        ];
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "";
        ReadWritePaths = lib.optionals (!cfg.autoMount) [
          ""
          cfg.dataDir
        ];
        # Make sure the socket units are started before ipfs.service
        Sockets = [
          "ipfs-gateway.socket"
          "ipfs-api.socket"
        ];
      }
      // lib.optionalAttrs (cfg.serviceFdlimit != null) { LimitNOFILE = cfg.serviceFdlimit; };
    }
    // lib.optionalAttrs (!cfg.startWhenNeeded) {
      wantedBy = [ "default.target" ];
    };

    systemd.sockets.ipfs-gateway = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = [ "" ] ++ (multiaddrsToListenStreams cfg.settings.Addresses.Gateway);
        ListenDatagram = [ "" ] ++ (multiaddrsToListenDatagrams cfg.settings.Addresses.Gateway);
      };
    };

    systemd.sockets.ipfs-api = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        # We also include "%t/ipfs.sock" because there is no way to put the "%t"
        # in the multiaddr.
        ListenStream = [
          ""
          "%t/ipfs.sock"
        ]
        ++ (multiaddrsToListenStreams cfg.settings.Addresses.API);
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
    (lib.mkRenamedOptionModule [ "services" "ipfs" "enable" ] [ "services" "kubo" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "package" ] [ "services" "kubo" "package" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "user" ] [ "services" "kubo" "user" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "group" ] [ "services" "kubo" "group" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "dataDir" ] [ "services" "kubo" "dataDir" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "defaultMode" ] [ "services" "kubo" "defaultMode" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "autoMount" ] [ "services" "kubo" "autoMount" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "autoMigrate" ] [ "services" "kubo" "autoMigrate" ])
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "ipfsMountDir" ]
      [ "services" "kubo" "settings" "Mounts" "IPFS" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "ipnsMountDir" ]
      [ "services" "kubo" "settings" "Mounts" "IPNS" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "gatewayAddress" ]
      [ "services" "kubo" "settings" "Addresses" "Gateway" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "apiAddress" ]
      [ "services" "kubo" "settings" "Addresses" "API" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "swarmAddress" ]
      [ "services" "kubo" "settings" "Addresses" "Swarm" ]
    )
    (lib.mkRenamedOptionModule [ "services" "ipfs" "enableGC" ] [ "services" "kubo" "enableGC" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "emptyRepo" ] [ "services" "kubo" "emptyRepo" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "extraConfig" ] [ "services" "kubo" "settings" ])
    (lib.mkRenamedOptionModule [ "services" "ipfs" "extraFlags" ] [ "services" "kubo" "extraFlags" ])
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "localDiscovery" ]
      [ "services" "kubo" "localDiscovery" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "serviceFdlimit" ]
      [ "services" "kubo" "serviceFdlimit" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "ipfs" "startWhenNeeded" ]
      [ "services" "kubo" "startWhenNeeded" ]
    )
    (lib.mkRenamedOptionModule [ "services" "kubo" "extraConfig" ] [ "services" "kubo" "settings" ])
    (lib.mkRenamedOptionModule
      [ "services" "kubo" "gatewayAddress" ]
      [ "services" "kubo" "settings" "Addresses" "Gateway" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "kubo" "apiAddress" ]
      [ "services" "kubo" "settings" "Addresses" "API" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "kubo" "swarmAddress" ]
      [ "services" "kubo" "settings" "Addresses" "Swarm" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "kubo" "ipfsMountDir" ]
      [ "services" "kubo" "settings" "Mounts" "IPFS" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "kubo" "ipnsMountDir" ]
      [ "services" "kubo" "settings" "Mounts" "IPNS" ]
    )
  ];
}
