{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscale-cert;
  opt = options.services.tailscale-cert;
in
{
  options.services.tailscale-cert = {
    enable = lib.mkEnableOption "the Tailscale cert service";

    package = lib.mkPackageOption pkgs "tailscale" { };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Tailnet domain for which to request the certificate";
      example = "monitoring.tailnet0123.ts.net";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "tailscale-cert";
      description = ''
        Directory name under `/var/lib/` where to store certificates and keys.
      '';
    };

    certFile = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.domain}.crt";
      defaultText = lib.literalExpression ''
        "''${config.${opt.domain}}.crt"
      '';

      description = "File name for cert under {var}`services.tailscale-cert.dataDir`";
    };

    keyFile = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.domain}.key";
      defaultText = lib.literalExpression ''
        "''${config.${opt.domain}}.crt"
      '';
      description = "File name for key file under {var}`services.tailscale-cert.dataDir`";
    };

    minValidity = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "90d";
      description = "Ensure the certificate is valid for at least this duration. The output certificate is never expired if this option is `null` or 0, but the lifetime may vary. The maximum allowed min-validity depends on the CA";
    };

    frequency = lib.mkOption {
      type = lib.types.str;
      default = "monthly";
      description = "How often to run the `tailscale cert` command. See {manpage}`systemd.time(7)` for the syntax.";
    };

    configureNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure the Nginx virtual host matching {var}`services.tailscale-cert.domain` with the Tailscale certificate and key";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        systemd.services.tailscale-cert = {
          description = "Tailscale cert service";
          requires = [ "network-online.target" ];
          after = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";

            StateDirectory = cfg.dataDir;
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            RemoveIPC = true;
            PrivateMounts = true;
            ProtectSystem = "strict";
            SystemCallFilter = [ "@system-service" ];
            NoNewPrivileges = true;

            ExecStart = toString [
              "${lib.getExe cfg.package} cert"
              "--cert-file /var/lib/${cfg.dataDir}/${cfg.certFile}"
              "--key-file /var/lib/${cfg.dataDir}/${cfg.keyFile}"
              (lib.optionalString (cfg.minValidity != null) "--min-validity ${cfg.minValidity}")
              cfg.domain
            ];
          };
        };

        systemd.timers.tailscale-cert = {
          description = "Fetch HTTPS certificates with `tailscale cert`";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            Unit = "tailscale-cert.service";
            # Ensure timer starts when first activated
            OnActiveSec = 0;
            # Ensure timer runs at regular intervals
            OnCalendar = cfg.frequency;
          };
        };
      }
      (lib.mkIf cfg.configureNginx (
        let
          certFile = "/var/lib/${cfg.dataDir}/${cfg.certFile}";
          keyFile = "/var/lib/${cfg.dataDir}/${cfg.keyFile}";
          nginxUser = config.services.nginx.user;
          nginxGroup = config.services.nginx.group;
        in
        {
          services.nginx = {
            enable = lib.mkDefault true;

            virtualHosts."${cfg.domain}" = {
              sslCertificate = certFile;
              sslCertificateKey = keyFile;
            };
          };
          systemd.services.nginx.serviceConfig.ReadOnlyPaths = [
            certFile
            keyFile
          ];
          systemd.services.tailscale-cert = {
            requiredBy = [ "nginx.service" ];
            before = [ "nginx.service" ];
            serviceConfig.ExecStartPost = ''
              ${pkgs.coreutils}/bin/chown ${nginxUser}:${nginxGroup} ${certFile} ${keyFile}
            '';
          };
        }
      ))
    ]
  );

  meta.maintainers = [ lib.maintainers.asymmetric ];
}
