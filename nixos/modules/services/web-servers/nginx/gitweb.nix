{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.nginx.gitweb;
  gitwebConfig = config.services.gitweb;
  package = pkgs.gitweb.override (
    optionalAttrs gitwebConfig.gitwebTheme {
      gitwebTheme = true;
    }
  );

in
{

  options.services.nginx.gitweb = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable gitweb in nginx.
      '';
    };

    location = mkOption {
      default = "/gitweb";
      type = types.str;
      description = ''
        Location to serve gitweb on.
      '';
    };

    user = mkOption {
      default = "nginx";
      type = types.str;
      description = ''
        Existing user that the CGI process will belong to. (Default almost surely will do.)
      '';
    };

    group = mkOption {
      default = "nginx";
      type = types.str;
      description = ''
        Group that the CGI process will belong to. (Set to `config.services.gitolite.group` if you are using gitolite.)
      '';
    };

    virtualHost = mkOption {
      default = "_";
      type = types.str;
      description = ''
        VirtualHost to serve gitweb on. Default is catch-all.
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.services.gitweb = {
      description = "GitWeb service";
      script = "${package}/gitweb.cgi --fastcgi --nproc=1";
      environment = {
        FCGI_SOCKET_PATH = "/run/gitweb/gitweb.sock";
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = [ "gitweb" ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    services.nginx = {
      virtualHosts.${cfg.virtualHost} = {
        locations."${cfg.location}/static/" = {
          alias = "${package}/static/";
        };
        locations."${cfg.location}/" = {
          extraConfig = ''
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_param GITWEB_CONFIG ${gitwebConfig.gitwebConfigFile};
            fastcgi_pass unix:/run/gitweb/gitweb.sock;
            fastcgi_split_path_info ^(${cfg.location}/)(.*)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
          '';
        };
      };
    };

  };

  meta.maintainers = [ ];

}
