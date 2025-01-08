{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  inherit (lib)
    mkRenamedOptionModule
    mkAliasOptionModuleMD
    mkEnableOption
    lib.mkOption
    types
    literalExpression
    mkPackageOption
    mkIf
    lib.optionalString
    lib.optional
    mkDefault
    escapeShellArgs
    lib.optionalAttrs
    mkMerge
    ;

  cfg = config.services.transmission;
  opt = options.services.transmission;
  inherit (config.environment) etc;
  apparmor = config.security.apparmor;
  rootDir = "/run/transmission";
  settingsDir = ".config/transmission-daemon";
  downloadsDir = "Downloads";
  incompleteDir = ".incomplete";
  watchDir = "watchdir";
  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "settings.json" cfg.settings;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "transmission"
        "port"
      ]
      [
        "services"
        "transmission"
        "settings"
        "rpc-port"
      ]
    )
    (mkAliasOptionModuleMD
      [
        "services"
        "transmission"
        "openFirewall"
      ]
      [
        "services"
        "transmission"
        "openPeerPorts"
      ]
    )
  ];
  options = {
    services.transmission = {
      enable = lib.mkEnableOption "transmission" // {
        description = ''
          Whether to enable the headless Transmission BitTorrent daemon.

          Transmission daemon can be controlled via the RPC interface using
          transmission-remote, the WebUI (http://127.0.0.1:9091/ by default),
          or other clients like stig or tremc.

          Torrents are downloaded to [](#opt-services.transmission.home)/${downloadsDir} by default and are
          accessible to users in the "transmission" group.
        '';
      };

      settings = lib.mkOption {
        description = ''
          Settings whose options overwrite fields in
          `.config/transmission-daemon/settings.json`
          (each time the service starts).

          See [Transmission's Wiki](https://github.com/transmission/transmission/wiki/Editing-Configuration-Files)
          for documentation of settings not explicitly covered by this module.
        '';
        default = { };
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            download-dir = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.home}/${downloadsDir}";
              defaultText = lib.literalExpression ''"''${config.${opt.home}}/${downloadsDir}"'';
              description = "Directory where to download torrents.";
            };
            incomplete-dir = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.home}/${incompleteDir}";
              defaultText = lib.literalExpression ''"''${config.${opt.home}}/${incompleteDir}"'';
              description = ''
                When enabled with
                services.transmission.home
                [](#opt-services.transmission.settings.incomplete-dir-enabled),
                new torrents will download the files to this directory.
                When complete, the files will be moved to download-dir
                [](#opt-services.transmission.settings.download-dir).
              '';
            };
            incomplete-dir-enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "";
            };
            message-level = lib.mkOption {
              type = lib.types.ints.between 0 6;
              default = 2;
              description = "Set verbosity of transmission messages.";
            };
            peer-port = lib.mkOption {
              type = lib.types.port;
              default = 51413;
              description = "The peer port to listen for incoming connections.";
            };
            peer-port-random-high = lib.mkOption {
              type = lib.types.port;
              default = 65535;
              description = ''
                The maximum peer port to listen to for incoming connections
                when [](#opt-services.transmission.settings.peer-port-random-on-start) is enabled.
              '';
            };
            peer-port-random-low = lib.mkOption {
              type = lib.types.port;
              default = 65535;
              description = ''
                The minimal peer port to listen to for incoming connections
                when [](#opt-services.transmission.settings.peer-port-random-on-start) is enabled.
              '';
            };
            peer-port-random-on-start = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Randomize the peer port.";
            };
            rpc-bind-address = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              example = "0.0.0.0";
              description = ''
                Where to listen for RPC connections.
                Use `0.0.0.0` to listen on all interfaces.
              '';
            };
            rpc-port = lib.mkOption {
              type = lib.types.port;
              default = 9091;
              description = "The RPC port to listen to.";
            };
            script-torrent-done-enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to run
                [](#opt-services.transmission.settings.script-torrent-done-filename)
                at torrent completion.
              '';
            };
            script-torrent-done-filename = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = "Executable to be run at torrent completion.";
            };
            umask = lib.mkOption {
              type = lib.types.either types.int types.str;
              default = if cfg.package == pkgs.transmission_3 then 18 else "022";
              defaultText = lib.literalExpression "if cfg.package == pkgs.transmission_3 then 18 else \"022\"";
              description = ''
                Sets transmission's file mode creation mask.
                See the umask(2) manpage for more information.
                Users who want their saved torrents to be world-writable
                may want to set this value to 0/`"000"`.

                Keep in mind, that if you are using Transmission 3, this has to
                be passed as a base 10 integer, whereas Transmission 4 takes
                an octal number in a string instead.
              '';
            };
            utp-enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Whether to enable [Micro Transport Protocol (µTP)](https://en.wikipedia.org/wiki/Micro_Transport_Protocol).
              '';
            };
            watch-dir = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.home}/${watchDir}";
              defaultText = lib.literalExpression ''"''${config.${opt.home}}/${watchDir}"'';
              description = "Watch a directory for torrent files and add them to transmission.";
            };
            watch-dir-enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to enable the
                                [](#opt-services.transmission.settings.watch-dir).
              '';
            };
            trash-original-torrent-files = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to delete torrents added from the
                                [](#opt-services.transmission.settings.watch-dir).
              '';
            };
          };
        };
      };

      package = lib.mkPackageOption pkgs "transmission" {
        default = "transmission_3";
        example = "pkgs.transmission_4";
      };

      downloadDirPermissions = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "770";
        description = ''
          If not `null`, is used as the permissions
          set by `system.activationScripts.transmission-daemon`
          on the directories [](#opt-services.transmission.settings.download-dir),
          [](#opt-services.transmission.settings.incomplete-dir).
          and [](#opt-services.transmission.settings.watch-dir).
          Note that you may also want to change
          [](#opt-services.transmission.settings.umask).

          Keep in mind, that if the default user is used, the `home` directory
          is locked behind a `750` permission, which affects all subdirectories
          as well. There are 3 ways to get around this:

          1. (Recommended) add the users that should have access to the group
             set by [](#opt-services.transmission.group)
          2. Change [](#opt-services.transmission.settings.download-dir) to be
             under a directory that has the right permissions
          3. Change `systemd.services.transmission.serviceConfig.StateDirectoryMode`
             to the same value as this option
        '';
      };

      home = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/transmission";
        description = ''
          The directory where Transmission will create `${settingsDir}`.
          as well as `${downloadsDir}/` unless
          [](#opt-services.transmission.settings.download-dir) is changed,
          and `${incompleteDir}/` unless
          [](#opt-services.transmission.settings.incomplete-dir) is changed.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "transmission";
        description = "User account under which Transmission runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "transmission";
        description = "Group account under which Transmission runs.";
      };

      credentialsFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to a JSON file to be merged with the settings.
          Useful to merge a file which is better kept out of the Nix store
          to set secret config parameters like `rpc-password`.
        '';
        default = "/dev/null";
        example = "/var/lib/secrets/transmission/settings.json";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--log-debug" ];
        description = ''
          Extra flags passed to the transmission command in the service definition.
        '';
      };

      openPeerPorts = mkEnableOption "opening of the peer port(s) in the firewall";

      openRPCPort = mkEnableOption "opening of the RPC port in the firewall";

      performanceNetParameters = mkEnableOption "performance tweaks" // {
        description = ''
          Whether to enable tweaking of kernel parameters
          to open many more connections at the same time.

          Note that you may also want to increase
          `peer-limit-global`.
          And be aware that these settings are quite aggressive
          and might not suite your regular desktop use.
          For instance, SSH sessions may time out more easily.
        '';
      };

      webHome = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "pkgs.flood-for-transmission";
        description = ''
          If not `null`, sets the value of the `TRANSMISSION_WEB_HOME`
          environment variable used by the service. Useful for overriding
          the web interface files, without overriding the transmission
          package and thus requiring rebuilding it locally. Use this if
          you want to use an alternative web interface, such as
          `pkgs.flood-for-transmission`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Note that using systemd.tmpfiles would not work here
    # because it would fail when creating a directory
    # with a different owner than its parent directory, by saying:
    # Detected unsafe path transition /home/foo → /home/foo/Downloads during canonicalization of /home/foo/Downloads
    # when /home/foo is not owned by cfg.user.
    # Note also that using an ExecStartPre= wouldn't work either
    # because BindPaths= needs these directories before.
    system.activationScripts.transmission-daemon =
      ''
        install -d -m 700 -o '${cfg.user}' -g '${cfg.group}' '${cfg.home}/${settingsDir}'
      ''
      + lib.optionalString (cfg.downloadDirPermissions != null) ''
        install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.download-dir}'

        ${lib.optionalString cfg.settings.incomplete-dir-enabled ''
          install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.incomplete-dir}'
        ''}
        ${lib.optionalString cfg.settings.watch-dir-enabled ''
          install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.watch-dir}'
        ''}
      '';

    systemd.services.transmission = {
      description = "Transmission BitTorrent Service";
      after = [ "network.target" ] ++ lib.optional apparmor.enable "apparmor.service";
      requires = lib.optional apparmor.enable "apparmor.service";
      wantedBy = [ "multi-user.target" ];

      environment = {
        CURL_CA_BUNDLE = etc."ssl/certs/ca-certificates.crt".source;
        TRANSMISSION_WEB_HOME = lib.mkIf (cfg.webHome != null) cfg.webHome;
      };

      serviceConfig = {
        # Use "+" because credentialsFile may not be accessible to User= or Group=.
        ExecStartPre = [
          (
            "+"
            + pkgs.writeShellScript "transmission-prestart" ''
              set -eu${lib.optionalString (cfg.settings.message-level >= 3) "x"}
              ${pkgs.jq}/bin/jq --slurp add ${settingsFile} '${cfg.credentialsFile}' |
              install -D -m 600 -o '${cfg.user}' -g '${cfg.group}' /dev/stdin \
               '${cfg.home}/${settingsDir}/settings.json'
            ''
          )
        ];
        ExecStart = "${cfg.package}/bin/transmission-daemon -f -g ${cfg.home}/${settingsDir} ${lib.escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        # Create rootDir in the host's mount namespace.
        RuntimeDirectory = [ (baseNameOf rootDir) ];
        RuntimeDirectoryMode = "755";
        # This is for BindPaths= and BindReadOnlyPaths=
        # to allow traversal of directories they create in RootDirectory=.
        UMask = "0066";
        # Using RootDirectory= makes it possible
        # to use the same paths download-dir/incomplete-dir
        # (which appear in user's interfaces) without requiring cfg.user
        # to have access to their parent directories,
        # by using BindPaths=/BindReadOnlyPaths=.
        # Note that TemporaryFileSystem= could have been used instead
        # but not without adding some BindPaths=/BindReadOnlyPaths=
        # that would only be needed for ExecStartPre=,
        # because RootDirectoryStartOnly=true would not help.
        RootDirectory = rootDir;
        RootDirectoryStartOnly = true;
        MountAPIVFS = true;
        BindPaths =
          [
            "${cfg.home}/${settingsDir}"
            cfg.settings.download-dir
            # Transmission may need to read in the host's /run (eg. /run/systemd/resolve)
            # or write in its private /run (eg. /run/host).
            "/run"
          ]
          ++ lib.optional cfg.settings.incomplete-dir-enabled cfg.settings.incomplete-dir
          ++ lib.optional (
            cfg.settings.watch-dir-enabled && cfg.settings.trash-original-torrent-files
          ) cfg.settings.watch-dir;
        BindReadOnlyPaths =
          [
            # No confinement done of /nix/store here like in systemd-confinement.nix,
            # an AppArmor profile is provided to get a confinement based upon paths and rights.
            builtins.storeDir
            "/etc"
          ]
          ++ lib.optional (
            cfg.settings.script-torrent-done-enabled && cfg.settings.script-torrent-done-filename != null
          ) cfg.settings.script-torrent-done-filename
          ++ lib.optional (
            cfg.settings.watch-dir-enabled && !cfg.settings.trash-original-torrent-files
          ) cfg.settings.watch-dir;
        StateDirectory = [
          "transmission"
          "transmission/${settingsDir}"
          "transmission/${incompleteDir}"
          "transmission/${downloadsDir}"
          "transmission/${watchDir}"
        ];
        StateDirectoryMode = lib.mkDefault 750;
        # The following options are only for optimizing:
        # systemd-analyze security transmission
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = lib.mkDefault true;
        PrivateNetwork = lib.mkDefault false;
        PrivateTmp = true;
        PrivateUsers = lib.mkDefault true;
        ProtectClock = true;
        ProtectControlGroups = true;
        # ProtectHome=true would not allow BindPaths= to work across /home,
        # and ProtectHome=tmpfs would break statfs(),
        # preventing transmission-daemon to report the available free space.
        # However, RootDirectory= is used, so this is not a security concern
        # since there would be nothing in /home but any BindPaths= wanted by the user.
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        # AF_UNIX may become usable one day:
        # https://github.com/transmission/transmission/issues/441
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall
          # listed by perf stat -e 'syscalls:sys_enter_*' transmission-daemon -f
          # in tests, and seem likely not necessary for transmission-daemon.
          "~@aio"
          "~@chown"
          "~@keyring"
          "~@memlock"
          "~@resources"
          "~@setuid"
          "~@timer"
          # In the @privileged group, but reached when querying infos through RPC (eg. with stig).
          "quotactl"
        ];
        SystemCallArchitectures = "native";
      };
    };

    # It's useful to have transmission in path, e.g. for remote control
    environment.systemPackages = [ cfg.package ];

    users.users = lib.optionalAttrs (cfg.user == "transmission") {
      transmission = {
        group = cfg.group;
        uid = config.ids.uids.transmission;
        description = "Transmission BitTorrent user";
        home = cfg.home;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "transmission") {
      transmission = {
        gid = config.ids.gids.transmission;
      };
    };

    networking.firewall = lib.mkMerge [
      (lib.mkIf cfg.openPeerPorts (
        if cfg.settings.peer-port-random-on-start then
          {
            allowedTCPPortRanges = [
              {
                from = cfg.settings.peer-port-random-low;
                to = cfg.settings.peer-port-random-high;
              }
            ];
            allowedUDPPortRanges = [
              {
                from = cfg.settings.peer-port-random-low;
                to = cfg.settings.peer-port-random-high;
              }
            ];
          }
        else
          {
            allowedTCPPorts = [ cfg.settings.peer-port ];
            allowedUDPPorts = [ cfg.settings.peer-port ];
          }
      ))
      (lib.mkIf cfg.openRPCPort { allowedTCPPorts = [ cfg.settings.rpc-port ]; })
    ];

    boot.kernel.sysctl = lib.mkMerge [
      # Transmission uses a single UDP socket in order to implement multiple uTP sockets,
      # and thus expects large kernel buffers for the UDP socket,
      # https://trac.transmissionbt.com/browser/trunk/libtransmission/tr-udp.c?rev=11956.
      # at least up to the values hardcoded here:
      (lib.mkIf cfg.settings.utp-enabled {
        "net.core.rmem_max" = lib.mkDefault 4194304; # 4MB
        "net.core.wmem_max" = lib.mkDefault 1048576; # 1MB
      })
      (lib.mkIf cfg.performanceNetParameters {
        # Increase the number of available source (local) TCP and UDP ports to 49151.
        # Usual default is 32768 60999, ie. 28231 ports.
        # Find out your current usage with: ss -s
        "net.ipv4.ip_local_port_range" = lib.mkDefault "16384 65535";
        # Timeout faster generic TCP states.
        # Usual default is 600.
        # Find out your current usage with: watch -n 1 netstat -nptuo
        "net.netfilter.nf_conntrack_generic_timeout" = lib.mkDefault 60;
        # Timeout faster established but inactive connections.
        # Usual default is 432000.
        "net.netfilter.nf_conntrack_tcp_timeout_established" = lib.mkDefault 600;
        # Clear immediately TCP states after timeout.
        # Usual default is 120.
        "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = lib.mkDefault 1;
        # Increase the number of trackable connections.
        # Usual default is 262144.
        # Find out your current usage with: conntrack -C
        "net.netfilter.nf_conntrack_max" = lib.mkDefault 1048576;
      })
    ];

    security.apparmor.policies."bin.transmission-daemon".profile = ''
      include "${cfg.package.apparmor}/bin.transmission-daemon"
    '';
    security.apparmor.includes."local/bin.transmission-daemon" = ''
      r ${config.systemd.services.transmission.environment.CURL_CA_BUNDLE},

      owner rw ${cfg.home}/${settingsDir}/**,
      rw ${cfg.settings.download-dir}/**,
      ${lib.optionalString cfg.settings.incomplete-dir-enabled ''
        rw ${cfg.settings.incomplete-dir}/**,
      ''}
      ${lib.optionalString cfg.settings.watch-dir-enabled ''
        r${lib.optionalString cfg.settings.trash-original-torrent-files "w"} ${cfg.settings.watch-dir}/**,
      ''}
      profile dirs {
        rw ${cfg.settings.download-dir}/**,
        ${lib.optionalString cfg.settings.incomplete-dir-enabled ''
          rw ${cfg.settings.incomplete-dir}/**,
        ''}
        ${lib.optionalString cfg.settings.watch-dir-enabled ''
          r${lib.optionalString cfg.settings.trash-original-torrent-files "w"} ${cfg.settings.watch-dir}/**,
        ''}
      }

      ${lib.optionalString
        (cfg.settings.script-torrent-done-enabled && cfg.settings.script-torrent-done-filename != null)
        ''
          # Stack transmission_directories profile on top of
          # any existing profile for script-torrent-done-filename
          # FIXME: to be tested as I'm not sure it works well with NoNewPrivileges=
          # https://gitlab.com/apparmor/apparmor/-/wikis/AppArmorStacking#seccomp-and-no_new_privs
          px ${cfg.settings.script-torrent-done-filename} -> &@{dirs},
        ''
      }

      ${lib.optionalString (cfg.webHome != null) ''
        r ${cfg.webHome}/**,
      ''}
    '';
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}
