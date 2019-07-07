{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitweb;
  package = pkgs.gitweb.override (optionalAttrs cfg.gitwebTheme {
    gitwebTheme = true;
  });

in
{

  options.services.nginx.gitweb = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable gitweb in nginx. Access it at http://yourserver/gitweb
      '';
    };

  };

  config = mkIf config.services.nginx.gitweb.enable {

    systemd.services.gitweb = {
      description = "GitWeb service";
      script = "${package}/gitweb.cgi --fastcgi --nproc=1";
      environment  = {
        FCGI_SOCKET_PATH = "/run/gitweb/gitweb.sock";
      };
      serviceConfig = {
        User = "nginx";
        Group = "nginx";
        RuntimeDirectory = [ "gitweb" ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    services.nginx = {
      virtualHosts.default = {
        locations."/gitweb/static/" = {
          alias = "${package}/static/";
        };
        locations."/gitweb/" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param GITWEB_CONFIG ${cfg.gitwebConfigFile};
            fastcgi_pass unix:/run/gitweb/gitweb.sock;
          '';
        };
      };
    };

  };

  meta.maintainers = with maintainers; [ gnidorah ];

}
