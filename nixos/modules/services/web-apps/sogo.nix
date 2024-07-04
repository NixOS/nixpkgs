{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.sogo;

  preStart = pkgs.writeShellScriptBin "sogo-prestart" ''
    touch /etc/sogo/sogo.conf
    chown sogo:sogo /etc/sogo/sogo.conf
    chmod 640 /etc/sogo/sogo.conf

    ${if (cfg.configReplaces != {}) then ''
      # Insert secrets
      ${concatStringsSep "\n" (mapAttrsToList (k: v: ''export ${k}="$(cat "${v}" | tr -d '\n')"'') cfg.configReplaces)}

      ${pkgs.perl}/bin/perl -p ${concatStringsSep " " (mapAttrsToList (k: v: '' -e 's/${k}/''${ENV{"${k}"}}/g;' '') cfg.configReplaces)} /etc/sogo/sogo.conf.raw > /etc/sogo/sogo.conf
    '' else ''
      cp /etc/sogo/sogo.conf.raw /etc/sogo/sogo.conf
    ''}
  '';

in {
  options.services.sogo = with types; {
    enable = mkEnableOption "SOGo groupware";

    vhostName = mkOption {
      description = "Name of the nginx vhost";
      type = str;
      default = "sogo";
    };

    timezone = mkOption {
      description = "Timezone of your SOGo instance";
      type = str;
      example = "America/Montreal";
    };

    language = mkOption {
      description = "Language of SOGo";
      type = str;
      default = "English";
    };

    ealarmsCredFile = mkOption {
      description = "Optional path to a credentials file for email alarms";
      type = nullOr str;
      default = null;
    };

    configReplaces = mkOption {
      description = ''
        Replacement-filepath mapping for sogo.conf.
        Every key is replaced with the contents of the file specified as value.

        In the example, every occurrence of LDAP_BINDPW will be replaced with the text of the
        specified file.
      '';
      type = attrsOf str;
      default = {};
      example = {
        LDAP_BINDPW = "/var/lib/secrets/sogo/ldappw";
      };
    };

    extraConfig = mkOption {
      description = "Extra sogo.conf configuration lines";
      type = lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sogo ];

    environment.etc."sogo/sogo.conf.raw".text = ''
      {
        // Mandatory parameters
        SOGoTimeZone = "${cfg.timezone}";
        SOGoLanguage = "${cfg.language}";
        // Paths
        WOSendMail = "/run/wrappers/bin/sendmail";
        SOGoMailSpoolPath = "/var/lib/sogo/spool";
        // Enable CSRF protection
        SOGoXSRFValidationEnabled = YES;
        // Remove dates from log (jornald does that)
        NGLogDefaultLogEventFormatterClass = "NGLogEventFormatter";
        // Extra config
        ${cfg.extraConfig}
      }
    '';

    systemd.services.sogo = {
      description = "SOGo groupware";
      after = [ "postgresql.service" "mysql.service" "memcached.service" "openldap.service" "dovecot2.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."sogo/sogo.conf.raw".source ];

      environment.LDAPTLS_CACERT = "/etc/ssl/certs/ca-certificates.crt";

      serviceConfig = {
        Type = "forking";
        ExecStartPre = "+" + preStart + "/bin/sogo-prestart";
        ExecStart = "${pkgs.sogo}/bin/sogod -WOLogFile - -WOPidFile /run/sogo/sogo.pid";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RuntimeDirectory = "sogo";
        StateDirectory = "sogo/spool";

        User = "sogo";
        Group = "sogo";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        PrivateUsers = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = "@basic-io @file-system @network-io @system-service @timer";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };
    };

    systemd.services.sogo-tmpwatch = {
      description = "SOGo tmpwatch";

      startAt = [ "hourly" ];
      script = ''
        SOGOSPOOL=/var/lib/sogo/spool

        find "$SOGOSPOOL" -type f -user sogo -atime +23 -delete > /dev/null
        find "$SOGOSPOOL" -mindepth 1 -type d -user sogo -empty -delete > /dev/null
      '';

      serviceConfig = {
        Type = "oneshot";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        StateDirectory = "sogo/spool";

        User = "sogo";
        Group = "sogo";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        PrivateUsers = true;
        PrivateNetwork = true;
        SystemCallFilter = "@basic-io @file-system @system-service";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "";
      };
    };

    systemd.services.sogo-ealarms = {
      description = "SOGo email alarms";

      after = [ "postgresql.service" "mysqld.service" "memcached.service" "openldap.service" "dovecot2.service" "sogo.service" ];
      restartTriggers = [ config.environment.etc."sogo/sogo.conf.raw".source ];

      startAt = [ "minutely" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.sogo}/bin/sogo-ealarms-notify${optionalString (cfg.ealarmsCredFile != null) " -p ${cfg.ealarmsCredFile}"}";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        StateDirectory = "sogo/spool";

        User = "sogo";
        Group = "sogo";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        PrivateUsers = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = "@basic-io @file-system @network-io @system-service";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };
    };

    # nginx vhost
    services.nginx.virtualHosts."${cfg.vhostName}" = {
      locations."/".extraConfig = ''
        rewrite ^ https://$server_name/SOGo;
        allow all;
      '';

      # For iOS 7
      locations."/principals/".extraConfig = ''
        rewrite ^ https://$server_name/SOGo/dav;
        allow all;
      '';

      locations."^~/SOGo".extraConfig = ''
        proxy_pass http://127.0.0.1:20000;
        proxy_redirect http://127.0.0.1:20000 default;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header x-webobjects-server-protocol HTTP/1.0;
        proxy_set_header x-webobjects-remote-host 127.0.0.1;
        proxy_set_header x-webobjects-server-port $server_port;
        proxy_set_header x-webobjects-server-name $server_name;
        proxy_set_header x-webobjects-server-url $scheme://$host;
        proxy_connect_timeout 90;
        proxy_send_timeout 90;
        proxy_read_timeout 90;
        proxy_buffer_size 64k;
        proxy_buffers 8 64k;
        proxy_busy_buffers_size 64k;
        proxy_temp_file_write_size 64k;
        client_max_body_size 50m;
        client_body_buffer_size 128k;
        break;
      '';

      locations."/SOGo.woa/WebServerResources/".extraConfig = ''
        alias ${pkgs.sogo}/lib/GNUstep/SOGo/WebServerResources/;
        allow all;
      '';

      locations."/SOGo/WebServerResources/".extraConfig = ''
        alias ${pkgs.sogo}/lib/GNUstep/SOGo/WebServerResources/;
        allow all;
      '';

      locations."~ ^/SOGo/so/ControlPanel/Products/([^/]*)/Resources/(.*)$".extraConfig = ''
        alias ${pkgs.sogo}/lib/GNUstep/SOGo/$1.SOGo/Resources/$2;
      '';

      locations."~ ^/SOGo/so/ControlPanel/Products/[^/]*UI/Resources/.*\\.(jpg|png|gif|css|js)$".extraConfig = ''
        alias ${pkgs.sogo}/lib/GNUstep/SOGo/$1.SOGo/Resources/$2;
      '';
    };

    # User and group
    users.groups.sogo = {};
    users.users.sogo = {
      group = "sogo";
      isSystemUser = true;
      description = "SOGo service user";
    };
  };
}
