{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.transmission;
  inherit (config.environment) etc;
  apparmor = config.security.apparmor;
  rootDir = "/run/transmission";
  settingsDir = ".config/transmission-daemon";
  downloadsDir = "Downloads";
  incompleteDir = ".incomplete";
  watchDir = "watchdir";
  settingsFormat = pkgs.formats.json {};
  settingsFile = settingsFormat.generate "settings.json" cfg.settings;
in
{
  imports = [
    (mkRenamedOptionModule ["services" "transmission" "port"]
                           ["services" "transmission" "settings" "rpc-port"])
    (mkAliasOptionModule ["services" "transmission" "openFirewall"]
                         ["services" "transmission" "openPeerPorts"])
  ];
  options = {
    services.transmission = {
      enable = mkEnableOption ''the headless Transmission BitTorrent daemon.

        Transmission daemon can be controlled via the RPC interface using
        transmission-remote, the WebUI (http://127.0.0.1:9091/ by default),
        or other clients like stig or tremc.

        Torrents are downloaded to <xref linkend="opt-services.transmission.home"/>/${downloadsDir} by default and are
        accessible to users in the "transmission" group'';

      settings = mkOption {
        description = ''
          Settings whose options overwrite fields in
          <literal>.config/transmission-daemon/settings.json</literal>
          (each time the service starts).

          See <link xlink:href="https://github.com/transmission/transmission/wiki/Editing-Configuration-Files">Transmission's Wiki</link>
          for documentation of settings not explicitely covered by this module.
        '';
        default = {};
        type = types.submodule {
          freeformType = settingsFormat.type;
          options.download-dir = mkOption {
            type = types.path;
            default = "${cfg.home}/${downloadsDir}";
            description = "Directory where to download torrents.";
          };
          options.incomplete-dir = mkOption {
            type = types.path;
            default = "${cfg.home}/${incompleteDir}";
            description = ''
              When enabled with
              services.transmission.home
              <xref linkend="opt-services.transmission.settings.incomplete-dir-enabled"/>,
              new torrents will download the files to this directory.
              When complete, the files will be moved to download-dir
              <xref linkend="opt-services.transmission.settings.download-dir"/>.
            '';
          };
          options.incomplete-dir-enabled = mkOption {
            type = types.bool;
            default = true;
            description = "";
          };
          options.message-level = mkOption {
            type = types.ints.between 0 3;
            default = 2;
            description = "Set verbosity of transmission messages.";
          };
          options.peer-port = mkOption {
            type = types.port;
            default = 51413;
            description = "The peer port to listen for incoming connections.";
          };
          options.peer-port-random-high = mkOption {
            type = types.port;
            default = 65535;
            description = ''
              The maximum peer port to listen to for incoming connections
              when <xref linkend="opt-services.transmission.settings.peer-port-random-on-start"/> is enabled.
            '';
          };
          options.peer-port-random-low = mkOption {
            type = types.port;
            default = 65535;
            description = ''
              The minimal peer port to listen to for incoming connections
              when <xref linkend="opt-services.transmission.settings.peer-port-random-on-start"/> is enabled.
            '';
          };
          options.peer-port-random-on-start = mkOption {
            type = types.bool;
            default = false;
            description = "Randomize the peer port.";
          };
          options.rpc-bind-address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = ''
              Where to listen for RPC connections.
              Use \"0.0.0.0\" to listen on all interfaces.
            '';
          };
          options.rpc-port = mkOption {
            type = types.port;
            default = 9091;
            description = "The RPC port to listen to.";
          };
          options.script-torrent-done-enabled = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to run
              <xref linkend="opt-services.transmission.settings.script-torrent-done-filename"/>
              at torrent completion.
            '';
          };
          options.script-torrent-done-filename = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = "Executable to be run at torrent completion.";
          };
          options.umask = mkOption {
            type = types.int;
            default = 2;
            description = ''
              Sets transmission's file mode creation mask.
              See the umask(2) manpage for more information.
              Users who want their saved torrents to be world-writable
              may want to set this value to 0.
              Bear in mind that the json markup language only accepts numbers in base 10,
              so the standard umask(2) octal notation "022" is written in settings.json as 18.
            '';
          };
          options.utp-enabled = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether to enable <link xlink:href="http://en.wikipedia.org/wiki/Micro_Transport_Protocol">Micro Transport Protocol (µTP)</link>.
            '';
          };
          options.watch-dir = mkOption {
            type = types.path;
            default = "${cfg.home}/${watchDir}";
            description = "Watch a directory for torrent files and add them to transmission.";
          };
          options.watch-dir-enabled = mkOption {
            type = types.bool;
            default = false;
            description = ''Whether to enable the
              <xref linkend="opt-services.transmission.settings.watch-dir"/>.
            '';
          };
          options.trash-original-torrent-files = mkOption {
            type = types.bool;
            default = false;
            description = ''Whether to delete torrents added from the
              <xref linkend="opt-services.transmission.settings.watch-dir"/>.
            '';
          };
        };
      };

      downloadDirPermissions = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "770";
        description = ''
          If not <code>null</code>, is used as the permissions
          set by <literal>systemd.activationScripts.transmission-daemon</literal>
          on the directories <xref linkend="opt-services.transmission.settings.download-dir"/>,
          <xref linkend="opt-services.transmission.settings.incomplete-dir"/>.
          and <xref linkend="opt-services.transmission.settings.watch-dir"/>.
          Note that you may also want to change
          <xref linkend="opt-services.transmission.settings.umask"/>.
        '';
      };

      home = mkOption {
        type = types.path;
        default = "/var/lib/transmission";
        description = ''
          The directory where Transmission will create <literal>${settingsDir}</literal>.
          as well as <literal>${downloadsDir}/</literal> unless
          <xref linkend="opt-services.transmission.settings.download-dir"/> is changed,
          and <literal>${incompleteDir}/</literal> unless
          <xref linkend="opt-services.transmission.settings.incomplete-dir"/> is changed.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "transmission";
        description = "User account under which Transmission runs.";
      };

      group = mkOption {
        type = types.str;
        default = "transmission";
        description = "Group account under which Transmission runs.";
      };

      credentialsFile = mkOption {
        type = types.path;
        description = ''
          Path to a JSON file to be merged with the settings.
          Useful to merge a file which is better kept out of the Nix store
          to set secret config parameters like <code>rpc-password</code>.
        '';
        default = "/dev/null";
        example = "/var/lib/secrets/transmission/settings.json";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--log-debug" ];
        description = ''
          Extra flags passed to the transmission command in the service definition.
        '';
      };

      openPeerPorts = mkEnableOption "opening of the peer port(s) in the firewall";

      openRPCPort = mkEnableOption "opening of the RPC port in the firewall";

      performanceNetParameters = mkEnableOption ''tweaking of kernel parameters
        to open many more connections at the same time.

        Note that you may also want to increase
        <code>peer-limit-global"</code>.
        And be aware that these settings are quite aggressive
        and might not suite your regular desktop use.
        For instance, SSH sessions may time out more easily'';
    };
  };

  config = mkIf cfg.enable {
    # Note that using systemd.tmpfiles would not work here
    # because it would fail when creating a directory
    # with a different owner than its parent directory, by saying:
    # Detected unsafe path transition /home/foo → /home/foo/Downloads during canonicalization of /home/foo/Downloads
    # when /home/foo is not owned by cfg.user.
    # Note also that using an ExecStartPre= wouldn't work either
    # because BindPaths= needs these directories before.
    system.activationScripts = mkIf (cfg.downloadDirPermissions != null)
      { transmission-daemon = ''
        install -d -m 700 '${cfg.home}/${settingsDir}'
        chown -R '${cfg.user}:${cfg.group}' ${cfg.home}/${settingsDir}
        install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.download-dir}'
        '' + optionalString cfg.settings.incomplete-dir-enabled ''
        install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.incomplete-dir}'
        '' + optionalString cfg.settings.watch-dir-enabled ''
        install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.watch-dir}'
        '';
      };

    systemd.services.transmission = {
      description = "Transmission BitTorrent Service";
      after = [ "network.target" ] ++ optional apparmor.enable "apparmor.service";
      requires = optional apparmor.enable "apparmor.service";
      wantedBy = [ "multi-user.target" ];
      environment.CURL_CA_BUNDLE = etc."ssl/certs/ca-certificates.crt".source;

      serviceConfig = {
        # Use "+" because credentialsFile may not be accessible to User= or Group=.
        ExecStartPre = [("+" + pkgs.writeShellScript "transmission-prestart" ''
          set -eu${lib.optionalString (cfg.settings.message-level >= 3) "x"}
          ${pkgs.jq}/bin/jq --slurp add ${settingsFile} '${cfg.credentialsFile}' |
          install -D -m 600 -o '${cfg.user}' -g '${cfg.group}' /dev/stdin \
           '${cfg.home}/${settingsDir}/settings.json'
        '')];
        ExecStart="${pkgs.transmission}/bin/transmission-daemon -f -g ${cfg.home}/${settingsDir} ${escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        # Create rootDir in the host's mount namespace.
        RuntimeDirectory = [(baseNameOf rootDir)];
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
          [ "${cfg.home}/${settingsDir}"
            cfg.settings.download-dir
          ] ++
          optional cfg.settings.incomplete-dir-enabled
            cfg.settings.incomplete-dir ++
          optional (cfg.settings.watch-dir-enabled && cfg.settings.trash-original-torrent-files)
            cfg.settings.watch-dir;
        BindReadOnlyPaths = [
          # No confinement done of /nix/store here like in systemd-confinement.nix,
          # an AppArmor profile is provided to get a confinement based upon paths and rights.
          builtins.storeDir
          "/etc"
          "/run"
          ] ++
          optional (cfg.settings.script-torrent-done-enabled &&
                    cfg.settings.script-torrent-done-filename != null)
            cfg.settings.script-torrent-done-filename ++
          optional (cfg.settings.watch-dir-enabled && !cfg.settings.trash-original-torrent-files)
            cfg.settings.watch-dir;
        StateDirectory = [
          "transmission"
          "transmission/.config/transmission-daemon"
          "transmission/.incomplete"
          "transmission/Downloads"
          "transmission/watch-dir"
        ];
        StateDirectoryMode = mkDefault 750;
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
        PrivateMounts = true;
        PrivateNetwork = mkDefault false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        # ProtectHome=true would not allow BindPaths= to work accross /home,
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
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall
          # listed by perf stat -e 'syscalls:sys_enter_*' transmission-daemon -f
          # in tests, and seem likely not necessary for transmission-daemon.
          "~@aio" "~@chown" "~@keyring" "~@memlock" "~@resources" "~@setuid" "~@timer"
          # In the @privileged group, but reached when querying infos through RPC (eg. with stig).
          "quotactl"
        ];
        SystemCallArchitectures = "native";
      };
    };

    # It's useful to have transmission in path, e.g. for remote control
    environment.systemPackages = [ pkgs.transmission ];

    users.users = optionalAttrs (cfg.user == "transmission") ({
      transmission = {
        group = cfg.group;
        uid = config.ids.uids.transmission;
        description = "Transmission BitTorrent user";
        home = cfg.home;
      };
    });

    users.groups = optionalAttrs (cfg.group == "transmission") ({
      transmission = {
        gid = config.ids.gids.transmission;
      };
    });

    networking.firewall = mkMerge [
      (mkIf cfg.openPeerPorts (
        if cfg.settings.peer-port-random-on-start
        then
          { allowedTCPPortRanges =
              [ { from = cfg.settings.peer-port-random-low;
                  to   = cfg.settings.peer-port-random-high;
                }
              ];
            allowedUDPPortRanges =
              [ { from = cfg.settings.peer-port-random-low;
                  to   = cfg.settings.peer-port-random-high;
                }
              ];
          }
        else
          { allowedTCPPorts = [ cfg.settings.peer-port ];
            allowedUDPPorts = [ cfg.settings.peer-port ];
          }
      ))
      (mkIf cfg.openRPCPort { allowedTCPPorts = [ cfg.settings.rpc-port ]; })
    ];

    boot.kernel.sysctl = mkMerge [
      # Transmission uses a single UDP socket in order to implement multiple uTP sockets,
      # and thus expects large kernel buffers for the UDP socket,
      # https://trac.transmissionbt.com/browser/trunk/libtransmission/tr-udp.c?rev=11956.
      # at least up to the values hardcoded here:
      (mkIf cfg.settings.utp-enabled {
        "net.core.rmem_max" = mkDefault "4194304"; # 4MB
        "net.core.wmem_max" = mkDefault "1048576"; # 1MB
      })
      (mkIf cfg.performanceNetParameters {
        # Increase the number of available source (local) TCP and UDP ports to 49151.
        # Usual default is 32768 60999, ie. 28231 ports.
        # Find out your current usage with: ss -s
        "net.ipv4.ip_local_port_range" = mkDefault "16384 65535";
        # Timeout faster generic TCP states.
        # Usual default is 600.
        # Find out your current usage with: watch -n 1 netstat -nptuo
        "net.netfilter.nf_conntrack_generic_timeout" = mkDefault 60;
        # Timeout faster established but inactive connections.
        # Usual default is 432000.
        "net.netfilter.nf_conntrack_tcp_timeout_established" = mkDefault 600;
        # Clear immediately TCP states after timeout.
        # Usual default is 120.
        "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = mkDefault 1;
        # Increase the number of trackable connections.
        # Usual default is 262144.
        # Find out your current usage with: conntrack -C
        "net.netfilter.nf_conntrack_max" = mkDefault 1048576;
      })
    ];

    security.apparmor.policies."bin.transmission-daemon".profile = ''
      include "${pkgs.transmission.apparmor}/bin.transmission-daemon"
    '';
    security.apparmor.includes."local/bin.transmission-daemon" = ''
      r ${config.systemd.services.transmission.environment.CURL_CA_BUNDLE},

      owner rw ${cfg.home}/${settingsDir}/**,
      rw ${cfg.settings.download-dir}/**,
      ${optionalString cfg.settings.incomplete-dir-enabled ''
        rw ${cfg.settings.incomplete-dir}/**,
      ''}
      ${optionalString cfg.settings.watch-dir-enabled ''
        r${optionalString cfg.settings.trash-original-torrent-files "w"} ${cfg.settings.watch-dir}/**,
      ''}
      profile dirs {
        rw ${cfg.settings.download-dir}/**,
        ${optionalString cfg.settings.incomplete-dir-enabled ''
          rw ${cfg.settings.incomplete-dir}/**,
        ''}
        ${optionalString cfg.settings.watch-dir-enabled ''
          r${optionalString cfg.settings.trash-original-torrent-files "w"} ${cfg.settings.watch-dir}/**,
        ''}
      }

      ${optionalString (cfg.settings.script-torrent-done-enabled &&
                        cfg.settings.script-torrent-done-filename != null) ''
        # Stack transmission_directories profile on top of
        # any existing profile for script-torrent-done-filename
        # FIXME: to be tested as I'm not sure it works well with NoNewPrivileges=
        # https://gitlab.com/apparmor/apparmor/-/wikis/AppArmorStacking#seccomp-and-no_new_privs
        px ${cfg.settings.script-torrent-done-filename} -> &@{dirs},
      ''}
    '';
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}
