{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.collabora;
  config_file = "/etc/collabora/coolwsd.xml";
  url = "http://${cfg.host}:${builtins.toString cfg.port}";
  inherit (lib) mkOption mkEnableOption mkIf types;
in {
  options.services.collabora = {
    enable = mkEnableOption "collabora document server";
    hostName = mkOption {
      type = types.str;
      description = "FQDN for the collabora instance";
      example = "office.example.com";
    };
    host = mkOption {
      type = types.str;
      description = "Hostname for the collabora instance";
      example = "192.168.0.2";
      default = "127.0.0.1";
    };
    port = mkOption {
      type = types.port;
      description = "Collabora Listening Port";
      default = 9980;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.collabora;
      description = "Which package to use for the colabora instance";
    };
    nginx = {
      enable = mkEnableOption "nginx proxy server";
    };
    dataDir = mkOption {
      type = types.str;
      description = "Data directory for the collabora instance";
      default = "/var/lib/collabora";
    };
    extraCLIArgs = mkOption {
      type = types.listOf types.str;
      description = "Extra CLI arguments when starting the collabora instance";
      default = [];
      example = lib.literalExpression ''
        [ "-o:ssl.enable=false" "--o:ssl.termination=true"]
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = mkIf cfg.nginx.enable {
      "${cfg.hostName}" = {
        locations = {
          # WOPI discovery URL
          "^~ /hosting/discovery" = {
            proxyPass = url;
            recommendedProxySettings = true;
          };

          # Capabilities
          "^~ /hosting/capabilities" = {
            proxyPass = url;
            recommendedProxySettings = true;
          };

          # main websocket
          "~ ^/cool/(.*)/ws$" = {
            proxyPass = url;
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_read_timeout 36000s;
            '';
          };

          # download, presentation and image upload
          # we accept 'lool' to be backward compatible
          "~ ^/(c|l)ool" = {
            proxyPass = url;
            recommendedProxySettings = true;
          };

          # Admin Console websocket
          "^~ /cool/adminws" = {
            proxyPass = url;
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_read_timeout 36000s;
            '';
          };
        };
      };
    };

    systemd.services.collabora = {
      description = "Collabora Document Server";
      wantedBy = ["multi-user.target"];
      path = [pkgs.cpio pkgs.coreutils pkgs.libreoffice-collabora-unwrapped];
      script = ''
        mkdir -p ${cfg.dataDir}/jail
        #if ! test -f "${cfg.dataDir}/template/.${cfg.package.version}"; then
        #  if test -d "${cfg.dataDir}/template"; then
        #    rm -rf ${cfg.dataDir}/template
        #  fi
        #  ${cfg.package}/bin/coolwsd-systemplate-setup "${cfg.dataDir}/template" "${pkgs.libreoffice-collabora-unwrapped}"
        #  touch ${cfg.dataDir}/template/.${cfg.package.version}
        #fi
        if ! test -f ${config_file}; then
          cp ${cfg.package}/etc/coolwsd/coolwsd.xml ${config_file}
        fi

        ${cfg.package}/bin/coolwsd --unattended \
          ${lib.concatStringsSep " " cfg.extraCLIArgs} \
          --port=${builtins.toString cfg.port} \
          "--config-file=${config_file}" \
          "--o:file_server_root_path=${cfg.package}/share/coolwsd" \
          --disable-cool-user-checking \
          "--o:child_root_path=${cfg.dataDir}/jail"

          #"--o:sys_template_path=${cfg.dataDir}/template" \

      '';
      environment = {HOME = "/var/lib/collabora";};
      serviceConfig = {
        DynamicUser = true;
        ConfigurationDirectory = "collabora";
        StateDirectory = "collabora";
        WorkingDirectory = "/var/lib/collabora";
        CapabilityBoundingSet = ["CAP_FOWNER" "CAP_MKNOD" "CAP_SYS_CHROOT"];
      };
    };
  };
}
