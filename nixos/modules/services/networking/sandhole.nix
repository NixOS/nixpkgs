{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sandhole;

  inherit (lib) types;

  name = "sandhole";

  stateDir = "/var/lib/${name}";

  sshPort = cfg.settings.ssh-port or 2222;

  httpPort = if cfg.settings.disable-http or false then null else cfg.settings.http-port or 80;

  httpsPort = if cfg.settings.disable-https or false then null else cfg.settings.https-port or 443;

  needsPrivilegedPorts =
    sshPort < 1024 || (httpPort != null && httpPort < 1024) || (httpsPort != null && httpsPort < 1024);

  settingsType = types.nullOr (
    types.oneOf [
      types.bool
      types.ints.unsigned
      types.path
      types.str
    ]
  );
in

{
  options = {
    services.sandhole = {
      enable = lib.mkEnableOption "Sandhole, a reverse proxy that lets you expose HTTP/SSH/TCP services through SSH port forwarding";

      package = lib.mkPackageOption pkgs "sandhole" { };

      user = lib.mkOption {
        type = types.str;
        default = name;
        description = ''
          User to run Sandhole as.
        '';
      };

      group = lib.mkOption {
        type = types.str;
        default = name;
        description = ''
          Group to run Sandhole as.
        '';
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open the necessary ports in the firewall.

          ::: {.warning}
          If this option is true and `services.sandhole.settings.disable-tcp` is false or unset,
          all unprivileged TCP ports (i.e. >= 1024) will be opened.
          :::

        '';
        example = true;
      };

      settings = lib.mkOption {
        type = types.attrsOf settingsType;
        # Default values for the CLI
        default = {
          domain = null;
          ssh-port = 2222;
          http-port = 80;
          https-port = 443;
          disable-http = false;
          disable-https = false;
          disable-tcp = false;
        };
        description = ''
          Attribute set of command line options for Sandhole, without the leading hyphens.

          If Sandhole is enabled, then `services.sandhole.settings.domain` must be set.

          ::: {.note}
          For all available settings, see [the Sandhole documentation](https://sandhole.com.br/cli.html).
          :::
        '';
        example = lib.literalExpression ''
          {
            domain = "sandhole.com.br";
            acme-contact-email = "admin@sandhole.com.br";
            ssh-port = 22;
            user-keys-directory = ./sandhole-user-keys;
            connect-ssh-on-https-port = true;
            load-balancing = "replace";
            allow-requested-subdomains = true;
            disable-tcp = true;
            ip-allowlist = "192.168.0.1,2001:db1::/32";
            idle-connection-timeout = "10s";
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings.domain or null) != null;
        message = "Sandhole requires services.sandhole.settings.domain to be set";
      }
    ];

    environment = {
      systemPackages = [ cfg.package ];
    };

    systemd.services.sandhole = {
      description = "Sandhole - Expose HTTP/SSH/TCP services through SSH port forwarding";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} ${lib.cli.toCommandLineShellGNU { } cfg.settings}";
        Type = "simple";
        Restart = "always";
        StateDirectory = name;
        StateDirectoryMode = "0750";
        WorkingDirectory = stateDir;
        AmbientCapabilities = lib.optional needsPrivilegedPorts "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = lib.optional needsPrivilegedPorts "CAP_NET_BIND_SERVICE";
        # Hardening
        NoNewPrivileges = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        PrivateMounts = true;
        PrivateUsers = !needsPrivilegedPorts; # Incompatible with CAP_NET_BIND_SERVICE
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectControlGroups = "strict";
        LockPersonality = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
      };
    };

    users.groups = lib.mkIf (cfg.group == name) { ${cfg.group} = { }; };

    users.users = lib.mkIf (cfg.user == name) {
      ${cfg.user} = {
        description = "Sandhole daemon user";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = lib.lists.filter (port: port != null) [
        sshPort
        httpPort
        httpsPort
      ];
      allowedTCPPortRanges = lib.optional (!(cfg.settings.disable-tcp or false)) {
        from = 1024;
        to = 65535;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ EpicEric ];
}
