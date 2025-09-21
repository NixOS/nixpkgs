{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.beszel;
in
{
  meta.maintainers = [ lib.maintainers.non-bin ];

  options.services.beszel = {
    agent = {
      enable = lib.mkEnableOption "agent";
      key = lib.mkOption {
        type = lib.types.str;
        description = "Public key(s) for SSH authentication";
        example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBvkz0O6T8dzn1yJTkj3wOSu/7IehuxVPSM5tKzsx5x";
      };
      listen = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:45876";
        description = "Address and port to listen on";
        example = "127.0.0.1:3265";
      };
    };

    hub = {
      enable = lib.mkEnableOption "hub";
      httpListen = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:80";
        description = "Address and port to listen for http traffic";
        example = "192.168.0.4:8090";
      };
      httpsListen = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Address and port to listen for https traffic. If specified, http traffic will be redirected to https";
        example = "0.0.0.0:443";
      };
      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Domains to listen on. If specified, http traffic will be redirected to https, and httpsListen will default to `0.0.0.0:443`";
        example = [ "example.com" ];
      };
    };
  };

  config = {
    environment.systemPackages = lib.mkIf (cfg.agent.enable || cfg.hub.enable) [ pkgs.beszel ];

    systemd.services = {
      beszel-agent = lib.mkIf cfg.agent.enable {
        description = "Beszel Monitoring System monitoring agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "networking.target" ];
        serviceConfig = {
          ExecStart = ''${pkgs.beszel}/bin/beszel-agent -key "${cfg.agent.key}" -listen "${cfg.agent.listen}"'';
        };
      };

      beszel-hub = lib.mkIf cfg.hub.enable {
        description = "Beszel Monitoring System hub server";
        wantedBy = [ "multi-user.target" ];
        after = [ "networking.target" ];
        serviceConfig = {
          ExecStart = ''${pkgs.beszel}/bin/beszel-hub serve ${
            if ((lib.length cfg.hub.domains) > 0) then
              (''"'' + (lib.concatStringsSep ''" "'' cfg.hub.domains) + ''"'')
            else
              ""
          } --http "${cfg.hub.httpListen}" --https "${cfg.hub.httpsListen}"'';
          WorkingDirectory = "/var/db/beszel";
        };
      };
    };
  };
}
