{ pkgs, config, lib, ... }:

let
  cfg = config.services.cockpit;
  inherit (lib) types mkEnableOption mkOption mkIf mdDoc literalMD mkPackageOption;
  settingsFormat = pkgs.formats.ini {};
in {
  options = {
    services.cockpit = {
      enable = mkEnableOption (mdDoc "Cockpit");

      package = mkPackageOption pkgs "Cockpit" {
        default = [ "cockpit" ];
      };

      settings = lib.mkOption {
        type = settingsFormat.type;

        default = {};

        description = mdDoc ''
          Settings for cockpit that will be saved in /etc/cockpit/cockpit.conf.

          See the [documentation](https://cockpit-project.org/guide/latest/cockpit.conf.5.html), that is also available with `man cockpit.conf.5` for details.
        '';
      };

      port = mkOption {
        description = mdDoc "Port where cockpit will listen.";
        type = types.port;
        default = 9090;
      };

      openFirewall = mkOption {
        description = mdDoc "Open port for cockpit.";
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    # expose cockpit-bridge system-wide
    environment.systemPackages = [ cfg.package ];

    # allow cockpit to find its plugins
    environment.pathsToLink = [ "/share/cockpit" ];

    # generate cockpit settings
    environment.etc."cockpit/cockpit.conf".source = settingsFormat.generate "cockpit.conf" cfg.settings;

    security.pam.services.cockpit = {};

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    # units are in reverse sort order if you ls $out/lib/systemd/system
    # all these units are basically verbatim translated from upstream

    # Translation from $out/lib/systemd/system/systemd-cockpithttps.slice
    systemd.slices.system-cockpithttps = {
      description = "Resource limits for all cockpit-ws-https@.service instances";
      sliceConfig = {
        TasksMax = 200;
        MemoryHigh = "75%";
        MemoryMax = "90%";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-https@.socket
    systemd.sockets."cockpit-wsinstance-https@" = {
      unitConfig = {
        Description = "Socket for Cockpit Web Service https instance %I";
        BindsTo = [ "cockpit.service" "cockpit-wsinstance-https@%i.service" ];
        # clean up the socket after the service exits, to prevent fd leak
        # this also effectively prevents a DoS by starting arbitrarily many sockets, as
        # the services are resource-limited by system-cockpithttps.slice
        Documentation = "man:cockpit-ws(8)";
      };
      socketConfig = {
        ListenStream = "/run/cockpit/wsinstance/https@%i.sock";
        SocketUser = "root";
        SocketMode = "0600";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-https@.service
    systemd.services."cockpit-wsinstance-https@" = {
      description = "Cockpit Web Service https instance %I";
      bindsTo = [ "cockpit.service"];
      path = [ cfg.package ];
      documentation = [ "man:cockpit-ws(8)" ];
      serviceConfig = {
        Slice = "system-cockpithttps.slice";
        ExecStart = "${cfg.package}/libexec/cockpit-ws --for-tls-proxy --port=0";
        User = "root";
        Group = "";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-http.socket
    systemd.sockets.cockpit-wsinstance-http = {
      unitConfig = {
        Description = "Socket for Cockpit Web Service http instance";
        BindsTo = "cockpit.service";
        Documentation = "man:cockpit-ws(8)";
      };
      socketConfig = {
        ListenStream = "/run/cockpit/wsinstance/http.sock";
        SocketUser = "root";
        SocketMode = "0600";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-https-factory.socket
    systemd.sockets.cockpit-wsinstance-https-factory = {
      unitConfig = {
        Description = "Socket for Cockpit Web Service https instance factory";
        BindsTo = "cockpit.service";
        Documentation = "man:cockpit-ws(8)";
      };
      socketConfig = {
        ListenStream = "/run/cockpit/wsinstance/https-factory.sock";
        Accept = true;
        SocketUser = "root";
        SocketMode = "0600";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-https-factory@.service
    systemd.services."cockpit-wsinstance-https-factory@" = {
      description = "Cockpit Web Service https instance factory";
      documentation = [ "man:cockpit-ws(8)" ];
      path = [ cfg.package ];
      serviceConfig = {
        ExecStart = "${cfg.package}/libexec/cockpit-wsinstance-factory";
        User = "root";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-wsinstance-http.service
    systemd.services."cockpit-wsinstance-http" = {
      description = "Cockpit Web Service http instance";
      bindsTo = [ "cockpit.service" ];
      path = [ cfg.package ];
      documentation = [ "man:cockpit-ws(8)" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/libexec/cockpit-ws --no-tls --port=0";
        User = "root";
        Group = "";
      };
    };

    # Translation from $out/lib/systemd/system/cockpit.socket
    systemd.sockets."cockpit" = {
      unitConfig = {
        Description = "Cockpit Web Service Socket";
        Documentation = "man:cockpit-ws(8)";
        Wants = "cockpit-motd.service";
      };
      socketConfig = {
        ListenStream = cfg.port;
        ExecStartPost = [
          "-${cfg.package}/share/cockpit/motd/update-motd \"\" localhost"
          "-${pkgs.coreutils}/bin/ln -snf active.motd /run/cockpit/motd"
        ];
        ExecStopPost = "-${pkgs.coreutils}/bin/ln -snf inactive.motd /run/cockpit/motd";
      };
      wantedBy = [ "sockets.target" ];
    };

    # Translation from $out/lib/systemd/system/cockpit.service
    systemd.services."cockpit" = {
      description = "Cockpit Web Service";
      documentation = [ "man:cockpit-ws(8)" ];
      restartIfChanged = true;
      path = with pkgs; [ coreutils cfg.package ];
      requires = [ "cockpit.socket" "cockpit-wsinstance-http.socket" "cockpit-wsinstance-https-factory.socket" ];
      after = [ "cockpit-wsinstance-http.socket" "cockpit-wsinstance-https-factory.socket" ];
      environment = {
        G_MESSAGES_DEBUG = "cockpit-ws,cockpit-bridge";
      };
      serviceConfig = {
        RuntimeDirectory="cockpit/tls";
        ExecStartPre = [
          # cockpit-tls runs in a more constrained environment, these + means that these commands
          # will run with full privilege instead of inside that constrained environment
          # See https://www.freedesktop.org/software/systemd/man/systemd.service.html#ExecStart= for details
          "+${cfg.package}/libexec/cockpit-certificate-ensure --for-cockpit-tls"
        ];
        ExecStart = "${cfg.package}/libexec/cockpit-tls";
        User = "root";
        Group = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        MemoryDenyWriteExecute = true;
      };
    };

    # Translation from $out/lib/systemd/system/cockpit-motd.service
    # This part basically implements a motd state machine:
    # - If cockpit.socket is enabled then /run/cockpit/motd points to /run/cockpit/active.motd
    # - If cockpit.socket is disabled then /run/cockpit/motd points to /run/cockpit/inactive.motd
    # - As cockpit.socket is disabled by default, /run/cockpit/motd points to /run/cockpit/inactive.motd
    # /run/cockpit/active.motd is generated dynamically by cockpit-motd.service
    systemd.services."cockpit-motd" = {
      path = with pkgs; [ nettools ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/share/cockpit/motd/update-motd";
      };
      description = "Cockpit motd updater service";
      documentation = [ "man:cockpit-ws(8)" ];
      wants = [ "network.target" ];
      after = [ "network.target" "cockpit.socket" ];
    };

    systemd.tmpfiles.rules = [ # From $out/lib/tmpfiles.d/cockpit-tmpfiles.conf
      "C /run/cockpit/inactive.motd 0640 root root - ${cfg.package}/share/cockpit/motd/inactive.motd"
      "f /run/cockpit/active.motd   0640 root root -"
      "L+ /run/cockpit/motd - - - - inactive.motd"
      "d /etc/cockpit/ws-certs.d 0600 root root 0"
    ];
  };

  meta.maintainers = pkgs.cockpit.meta.maintainers;
}
