{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services.etesync-web;
  etebaseHost = config.services.etebase-server.settings.allowed_hosts.allowed_host1;
  pkg = pkgs.etesync-web.override { inherit (cfg) defaultServer; };
  webRoot = "${pkg}/libexec/${pkg.pname}/deps/${pkg.pname}/build/";
in
{
  meta.maintainers = with maintainers; [ pacman99 ];
  options = {
    services.etesync-web = {
      enable = mkEnableOption "host etesync web interface with nginx";
      hostName = mkOption {
        type = types.str;
        description = ''
          The hostName to serve etesync-web from
        '';
      };
      defaultServer = mkOption {
        type = with types; nullOr str;
        default = if etebaseHost != "0.0.0.0" then etebaseHost else null;
        defaultText = ''
          if set ''${config.services.etebase-server.settings.allowed_hosts.allowed_host1}, otherwise https://etebase.com"
        '';
        description = ''
          The default etebase server to login to
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.hostName} = {
        locations."/" = {
          root = webRoot;
          tryFiles = "\$uri \$uri/ /index.html =404";
          extraConfig = ''
            autoindex on;
          '';
        };
        locations."= /50x.html".root = webRoot;
        extraConfig = ''
          error_page   500 502 503 504  /50x.html;
        '';
      };
    };
  };
}
