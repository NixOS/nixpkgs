{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.transmission;
  inherit (config.environment) etc;
  apparmor = config.security.apparmor.enable;
  rootDir = "/run/transmission";
  homeDir = "/var/lib/transmission";
  settingsDir = ".config/transmission-daemon";
  downloadsDir = "Downloads";
  incompleteDir = ".incomplete";
  # TODO: switch to configGen.json once RFC0042 is implemented
  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON cfg.settings);
in
{
  options = {
    services.transmission = {
      enable = mkEnableOption ''the headless Transmission BitTorrent daemon.

        Transmission daemon can be controlled via the RPC interface using
        transmission-remote, the WebUI (http://127.0.0.1:9091/ by default),
        or other clients like stig or tremc.

        Torrents are downloaded to ${homeDir}/${downloadsDir} by default and are
        accessible to users in the "transmission" group'';

      settings = mkOption rec {
        # TODO: switch to types.config.json as prescribed by RFC0042 once it's implemented
        type = types.attrs;
        apply = recursiveUpdate default;
        default =
          {
            download-dir = "${cfg.home}/${downloadsDir}";
            incomplete-dir = "${cfg.home}/${incompleteDir}";
            incomplete-dir-enabled = true;
            message-level = 1;
            peer-port = 51413;
            peer-port-random-high = 65535;
            peer-port-random-low = 49152;
            peer-port-random-on-start = false;
            rpc-bind-address = "127.0.0.1";
            rpc-port = 9091;
            script-torrent-done-enabled = false;
            script-torrent-done-filename = "";
            umask = 2; # 0o002 in decimal as expected by Transmission
            utp-enabled = true;
          };
        example =
          {
            download-dir = "/srv/torrents/";
            incomplete-dir = "/srv/torrents/.incomplete/";
            incomplete-dir-enabled = true;
            rpc-whitelist = "127.0.0.1,192.168.*.*";
          };
        description = ''
          Attribute set whose fields overwrites fields in
          <literal>.config/transmission-daemon/settings.json</literal>
          (each time the service starts). String values must be quoted, integer and
          boolean values must not.

          See <link xlink:href="https://github.com/transmission/transmission/wiki/Editing-Configuration-Files">Transmission's Wiki</link>
          for documentation.
        '';
      };

      downloadDirPermissions = mkOption {
        type = types.str;
        default = "770";
        example = "775";
        description = ''
          The permissions set by <literal>systemd.activationScripts.transmission-daemon</literal>
          on the directories <link linkend="opt-services.transmission.settings">settings.download-dir</link>
          and <link linkend="opt-services.transmission.settings">settings.incomplete-dir</link>.
          Note that you may also want to change
          <link linkend="opt-services.transmission.settings">settings.umask</link>.
        '';
      };

      port = mkOption {
        type = types.port;
        description = ''
          TCP port number to run the RPC/web interface.

          If instead you want to change the peer port,
          use <link linkend="opt-services.transmission.settings">settings.peer-port</link>
          or <link linkend="opt-services.transmission.settings">settings.peer-port-random-on-start</link>.
        '';
      };

      home = mkOption {
        type = types.path;
        default = homeDir;
        description = ''
          The directory where Transmission will create <literal>${settingsDir}</literal>.
          as well as <literal>${downloadsDir}/</literal> unless <link linkend="opt-services.transmission.settings">settings.download-dir</link> is changed,
          and <literal>${incompleteDir}/</literal> unless <link linkend="opt-services.transmission.settings">settings.incomplete-dir</link> is changed.
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
          because it contains sensible data like <link linkend="opt-services.transmission.settings">settings.rpc-password</link>.
        '';
        default = "/dev/null";
        example = "/var/lib/secrets/transmission/settings.json";
      };

      openFirewall = mkEnableOption "opening of the peer port(s) in the firewall";

      performanceNetParameters = mkEnableOption ''tweaking of kernel parameters
        to open many more connections at the same time.

        Note that you may also want to increase
        <link linkend="opt-services.transmission.settings">settings.peer-limit-global</link>.
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
    system.activationScripts.transmission-daemon = ''
      install -d -m 700 '${cfg.home}/${settingsDir}'
      chown -R '${cfg.user}:${cfg.group}' ${cfg.home}/${settingsDir}
      install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.download-dir}'
      '' + optionalString cfg.settings.incomplete-dir-enabled ''
      install -d -m '${cfg.downloadDirPermissions}' -o '${cfg.user}' -g '${cfg.group}' '${cfg.settings.incomplete-dir}'
      '';

    assertions = [
      { assertion = builtins.match "^/.*" cfg.home != null;
        message = "`services.transmission.home' must be an absolute path.";
      }
      { assertion = types.path.check cfg.settings.download-dir;
        message = "`services.transmission.settings.download-dir' must be an absolute path.";
      }
      { assertion = types.path.check cfg.settings.incomplete-dir;
        message = "`services.transmission.settings.incomplete-dir' must be an absolute path.";
      }
      { assertion = cfg.settings.script-torrent-done-filename == "" || types.path.check cfg.settings.script-torrent-done-filename;
        message = "`services.transmission.settings.script-torrent-done-filename' must be an absolute path.";
      }
      { assertion = types.port.check cfg.settings.rpc-port;
        message = "${toString cfg.settings.rpc-port} is not a valid port number for `services.transmission.settings.rpc-port`.";
      }
      # In case both port and settings.rpc-port are explicitely defined: they must be the same.
      { assertion = !options.services.transmission.port.isDefined || cfg.port == cfg.settings.rpc-port;
        message = "`services.transmission.port' is not equal to `services.transmission.settings.rpc-port'";
      }
    ];

    services.transmission.settings =
      optionalAttrs options.services.transmission.port.isDefined { rpc-port = cfg.port; };

    systemd.services.transmission = {
      description = "Transmission BitTorrent Service";
      after = [ "network.target" ] ++ optional apparmor "apparmor.service";
      requires = optional apparmor "apparmor.service";
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
        ExecStart="${pkgs.transmission}/bin/transmission-daemon -f";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        # Create rootDir in the host's mount namespace.
        RuntimeDirectory = [(baseNameOf rootDir)];
        RuntimeDirectoryMode = "755";
        # Avoid mounting rootDir in the own rootDir of ExecStart='s mount namespace.
        InaccessiblePaths = ["-+${rootDir}"];
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
            cfg.settings.incomplete-dir;
        BindReadOnlyPaths = [
          # No confinement done of /nix/store here like in systemd-confinement.nix,
          # an AppArmor profile is provided to get a confinement based upon paths and rights.
          builtins.storeDir
          "-/etc/hosts"
          "-/etc/ld-nix.so.preload"
          "-/etc/localtime"
          ] ++
          optional (cfg.settings.script-torrent-done-enabled &&
                    cfg.settings.script-torrent-done-filename != "")
            cfg.settings.script-torrent-done-filename;
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
        SystemCallErrorNumber = "EPERM";
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

    networking.firewall = mkIf cfg.openFirewall (
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
    );

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
        "net.ipv4.ip_local_port_range" = "16384 65535";
        # Timeout faster generic TCP states.
        # Usual default is 600.
        # Find out your current usage with: watch -n 1 netstat -nptuo
        "net.netfilter.nf_conntrack_generic_timeout" = 60;
        # Timeout faster established but inactive connections.
        # Usual default is 432000.
        "net.netfilter.nf_conntrack_tcp_timeout_established" = 600;
        # Clear immediately TCP states after timeout.
        # Usual default is 120.
        "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = 1;
        # Increase the number of trackable connections.
        # Usual default is 262144.
        # Find out your current usage with: conntrack -C
        "net.netfilter.nf_conntrack_max" = 1048576;
      })
    ];

    security.apparmor.profiles = mkIf apparmor [
      (pkgs.writeText "apparmor-transmission-daemon" ''
        include <tunables/global>

        ${pkgs.transmission}/bin/transmission-daemon {
          include <abstractions/base>
          include <abstractions/nameservice>

          # NOTE: https://github.com/NixOS/nixpkgs/pull/93457
          # will remove the need for these by fixing <abstractions/base>
          r ${etc."hosts".source},
          r /etc/ld-nix.so.preload,
          ${lib.optionalString (builtins.hasAttr "ld-nix.so.preload" etc) ''
            r ${etc."ld-nix.so.preload".source},
            ${concatMapStrings (p: optionalString (p != "") ("mr ${p},\n"))
              (splitString "\n" config.environment.etc."ld-nix.so.preload".text)}
          ''}
          r ${etc."ssl/certs/ca-certificates.crt".source},
          r ${pkgs.tzdata}/share/zoneinfo/**,
          r ${pkgs.stdenv.cc.libc}/share/i18n/**,
          r ${pkgs.stdenv.cc.libc}/share/locale/**,

          mr ${getLib pkgs.stdenv.cc.cc}/lib/*.so*,
          mr ${getLib pkgs.stdenv.cc.libc}/lib/*.so*,
          mr ${getLib pkgs.attr}/lib/libattr*.so*,
          mr ${getLib pkgs.c-ares}/lib/libcares*.so*,
          mr ${getLib pkgs.curl}/lib/libcurl*.so*,
          mr ${getLib pkgs.keyutils}/lib/libkeyutils*.so*,
          mr ${getLib pkgs.libcap}/lib/libcap*.so*,
          mr ${getLib pkgs.libevent}/lib/libevent*.so*,
          mr ${getLib pkgs.libgcrypt}/lib/libgcrypt*.so*,
          mr ${getLib pkgs.libgpgerror}/lib/libgpg-error*.so*,
          mr ${getLib pkgs.libkrb5}/lib/lib*.so*,
          mr ${getLib pkgs.libssh2}/lib/libssh2*.so*,
          mr ${getLib pkgs.lz4}/lib/liblz4*.so*,
          mr ${getLib pkgs.nghttp2}/lib/libnghttp2*.so*,
          mr ${getLib pkgs.openssl}/lib/libcrypto*.so*,
          mr ${getLib pkgs.openssl}/lib/libssl*.so*,
          mr ${getLib pkgs.systemd}/lib/libsystemd*.so*,
          mr ${getLib pkgs.utillinuxMinimal.out}/lib/libblkid.so*,
          mr ${getLib pkgs.utillinuxMinimal.out}/lib/libmount.so*,
          mr ${getLib pkgs.utillinuxMinimal.out}/lib/libuuid.so*,
          mr ${getLib pkgs.xz}/lib/liblzma*.so*,
          mr ${getLib pkgs.zlib}/lib/libz*.so*,

          r @{PROC}/sys/kernel/random/uuid,
          r @{PROC}/sys/vm/overcommit_memory,
          # @{pid} is not a kernel variable yet but a regexp
          #r @{PROC}/@{pid}/environ,
          r @{PROC}/@{pid}/mounts,
          rwk /tmp/tr_session_id_*,

          r ${pkgs.openssl.out}/etc/**,
          r ${config.systemd.services.transmission.environment.CURL_CA_BUNDLE},
          r ${pkgs.transmission}/share/transmission/**,

          owner rw ${cfg.home}/${settingsDir}/**,
          rw ${cfg.settings.download-dir}/**,
          ${optionalString cfg.settings.incomplete-dir-enabled ''
            rw ${cfg.settings.incomplete-dir}/**,
          ''}
          profile dirs {
            rw ${cfg.settings.download-dir}/**,
            ${optionalString cfg.settings.incomplete-dir-enabled ''
              rw ${cfg.settings.incomplete-dir}/**,
            ''}
          }

          ${optionalString (cfg.settings.script-torrent-done-enabled &&
                            cfg.settings.script-torrent-done-filename != "") ''
            # Stack transmission_directories profile on top of
            # any existing profile for script-torrent-done-filename
            # FIXME: to be tested as I'm not sure it works well with NoNewPrivileges=
            # https://gitlab.com/apparmor/apparmor/-/wikis/AppArmorStacking#seccomp-and-no_new_privs
            px ${cfg.settings.script-torrent-done-filename} -> &@{dirs},
          ''}

          # FIXME: enable customizing using https://github.com/NixOS/nixpkgs/pull/93457
          # include <local/transmission-daemon>
        }
      '')
    ];
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}
