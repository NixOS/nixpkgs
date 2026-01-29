{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.websurfx;
  user = "websurfx";
  dataDir = "/var/lib/${user}";

  defaultConfig = {
    logging = true;
    debug = false;
    threads = 10;
    port = "8080";
    binding_ip = "127.0.0.1";
    production_use = false;
    request_timeout = 30;
    tcp_connection_keep_alive = 30;
    pool_idle_connection_timeout = 30;
    rate_limiter = {
      number_of_requests = 20;
      time_limit = 3;
    };
    https_adaptive_window_size = true;
    operating_system_tls_certificates = true;
    number_of_https_connections = 10;
    client_connection_keep_alive = 120;
    safe_search = 2;
    colorscheme = "catppuccin-mocha";
    theme = "simple";
    animation = "simple-frosted-glow";
    redis_url = "redis://127.0.0.1:8082";
    cache_expiry_time = 600;
    upstream_search_engines = {
      DuckDuckGo = true;
      Searx = false;
      Brave = false;
      Startpage = false;
      LibreX = false;
      Mojeek = false;
      Bing = false;
      Wikipedia = true;
      Yahoo = false;
    };
    proxy = null;
  };
in
{
  options = {
    services.websurfx = {
      enable = lib.mkEnableOption "Websurfx, a metasearch engine";
      package = lib.mkPackageOption pkgs "websurfx" { };
      redis = {
        enable = lib.mkEnableOption "Websurfx analytics via Redis" // {
          default = true;
        };
        port = lib.mkOption {
          default = 4568;
          description = "Websurfx Redis port";
          type = lib.types.port;
        };
      };
      settings = lib.mkOption {
        default = {
          port = "4567";
          binding_ip = "127.0.0.1";
        };
        description = ''
          Configuration options for Websurfx, see
          <https://github.com/neon-mmd/websurfx/blob/rolling/websurfx/config.lua>
        '';
        type = lib.types.attrs;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      redis.servers.websurfx = {
        enable = cfg.redis.enable;
        port = cfg.redis.port;
      };
    };
    systemd.services.websurfx = {
      after = [ "network.target" ];
      description = "Websurfx, a metasearch engine";
      environment.HOME = dataDir;
      serviceConfig = {
        ExecStartPre = ''
          mkdir -p ".config/websurfx"
          cat '${
            (pkgs.formats.lua { asBindings = true; }).generate "config.lua" (
              defaultConfig
              // {
                redis_url = "redis://127.0.0.1:${toString cfg.redis.port}";
              }
              // cfg.settings
            )
          }' > ".config/websurfx/config.lua"
        '';
        ExecStart = lib.getExe cfg.package;
        User = user;
        WorkingDirectory = dataDir;
      };
      wantedBy = [ "multi-user.target" ];
    };
    users = {
      groups.${user} = { };
      users.${user} = {
        createHome = true;
        group = user;
        home = dataDir;
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = [ lib.maintainers.SchweGELBin ];
}
