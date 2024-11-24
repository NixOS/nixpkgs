{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.invidious-router;
  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in {
  meta.maintainers = [lib.maintainers.sils];

  options.services.invidious-router = {
    enable = lib.mkEnableOption "the invidious-router service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8050;
      description = ''
        Port to bind to.
      '';
    };
    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        Address on which invidious-router should listen on.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = {
        app = {
          listen = "127.0.0.1:8050";
          enable_youtube_fallback = false;
          reload_instance_list_interval = "60s";
        };
        api = {
          enabled = true;
          url = "https://api.invidious.io/instances.json";
          filter_regions = true;
          allowed_regions = [
            "AT"
            "DE"
            "CH"
          ];
        };
        healthcheck = {
          path = "/";
          allowed_status_codes = [
            200
          ];
          timeout = "1s";
          interval = "10s";
          filter_by_response_time = {
            enabled = true;
            qty_of_top_results = 3;
          };
          minimum_ratio = 0.2;
          remove_no_ratio = true;
          text_not_present = "YouTube is currently trying to block Invidious instances";
        };
      };
      description = ''
        Configuration for invidious-router.
        Check https://gitlab.com/gaincoder/invidious-router#configuration
        for configuration options.
      '';
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.invidious-router;
      defaultText = lib.literalExpression "pkgs.invidious-router";
      description = ''
        The invidious-router package to use.
      '';
    };
    nginx = {
      enable = lib.mkEnableOption ''
        Automatic nginx proxy configuration
      '';
      domain = lib.mkOption {
        type = lib.types.str;
        example = "invidious-router.example.com";
        description = ''
          The domain on which invidious-router should be served.
        '';
      };
      extraDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Additional domains to serve invidious-router on.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.invidious-router = {
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${lib.getExe cfg.package} --configfile ${configFile}";
        DynamicUser = "yes";
      };
    };

    services.nginx.virtualHosts = lib.mkIf cfg.nginx.enable {
      ${cfg.nginx.domain} = {
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://${cfg.address}:${toString cfg.port}";
        };
        enableACME = true;
        forceSSL = true;
        serverAliases = cfg.nginx.extraDomains;
      };
    };
  };
}
