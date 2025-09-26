{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.zellij;

in
{
  options = {
    services.zellij = {
      enable = lib.mkEnableOption "Enable Zellij";

      package = lib.mkPackageOption pkgs "zellij" { };

      user = lib.mkOption {
        type = lib.types.str;
        description = ''
          User that will run Zellij
        '';
      };

      enableBashIntegration = lib.mkEnableOption "Bash integration";
      enableFishIntegration = lib.mkEnableOption "Fish integration";

      web = {
        enable = lib.mkEnableOption "Enable Zellij web";

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Open port in the firewall.";
        };

        ip = lib.mkOption {
          type = lib.types.str;
          description = ''
            The ip address to listen on locally for connections
          '';
          default = "127.0.0.1";
          example = "0.0.0.0";
        };

        port = lib.mkOption {
          type = lib.types.port;
          description = ''
            The port to listen on locally for connections
          '';
          default = 8082;
        };

        certificate = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            The path to the SSL certificate (required if not listening on 127.0.0.1)

            Can be generated using this command
            mkcert -cert-file zellij-cert.pem -key-file zellij-key.pem zellij
          '';
          default = null;
          example = "config.age.secrets.zellij-cert.path";
        };

        key = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            The path to the SSL key (required if not listening on 127.0.0.1)

            Can be generated using this command
            mkcert -cert-file zellij-cert.pem -key-file zellij-key.pem zellij
          '';
          default = null;
          example = "config.age.secrets.zellij-key.path";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.web.ip != "127.0.0.1" -> (cfg.web.certificate != null && cfg.web.key != null);
        message = "Cannot bind to non-loopback IP: 0.0.0.0 without an SSL certificate, please set `services.zellij.web.certificate` and `services.zellij.web.key`. See https://github.com/zellij-org/zellij/issues/4347#issuecomment-3160010870";
      }
    ];

    programs.bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
      eval "$(${lib.getExe cfg.package} setup --generate-auto-start bash)"
    '';

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
      eval (${lib.getExe cfg.package} setup --generate-auto-start fish | string collect)
    '';

    systemd.user.services.zellij-web = lib.mkIf cfg.web.enable {
      after = lib.lists.optional (options ? age && options.age.secrets != { }) "agenix.service";
      wantedBy = [ "default.target" ];
      script = ''
        zellij web --start \
          ${lib.strings.optionalString (null != cfg.web.ip) "--ip ${cfg.web.ip}"} \
          ${lib.strings.optionalString (null != cfg.web.port) "--port ${builtins.toString cfg.web.port}"} \
          ${lib.strings.optionalString (null != cfg.web.certificate) "--cert ${cfg.web.certificate}"} \
          ${lib.strings.optionalString (null != cfg.web.key) "--key ${cfg.web.key}"}
      '';
      path = [
        cfg.package
      ];
      environment = {
        TERM = config.users.users."${cfg.user}".shell;
      };
    };

    users.users."${cfg.user}" = {
      packages = [
        cfg.package
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.web.enable && cfg.web.openFirewall) [
      cfg.web.port
    ];
  };
}
