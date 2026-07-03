{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gitweb;
  cfgNginx = config.services.gitweb.nginx;
  package = pkgs.gitweb.override (
    lib.optionalAttrs cfg.gitwebTheme {
      gitwebTheme = true;
    }
  );
in
{

  options.services.gitweb = {

    projectroot = lib.mkOption {
      default = "/srv/git";
      type = lib.types.path;
      description = ''
        Path to git projects (bare repositories) that should be served by
        gitweb. Must not end with a slash.
      '';
    };

    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Verbatim configuration text appended to the generated gitweb.conf file.
      '';
      example = ''
        $feature{'highlight'}{'default'} = [1];
        $feature{'ctags'}{'default'} = [1];
        $feature{'avatar'}{'default'} = ['gravatar'];
      '';
    };

    gitwebTheme = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Use an alternative theme for gitweb, strongly inspired by GitHub.
      '';
    };

    gitwebConfigFile = lib.mkOption {
      default = pkgs.writeText "gitweb.conf" ''
        # path to git projects (<project>.git)
        $projectroot = "${cfg.projectroot}";
        $highlight_bin = "${pkgs.highlight}/bin/highlight";
        ${cfg.extraConfig}
      '';
      defaultText = lib.literalMD "generated config file";
      type = lib.types.path;
      readOnly = true;
      internal = true;
    };

    nginx = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          If true, enable gitweb in nginx.
        '';
      };

      location = lib.mkOption {
        default = "/gitweb";
        type = lib.types.str;
        description = ''
          Location to serve gitweb on.
        '';
      };

      user = lib.mkOption {
        default = "nginx";
        type = lib.types.str;
        description = ''
          Existing user that the CGI process will belong to. (Default almost surely will do.)
        '';
      };

      group = lib.mkOption {
        default = "nginx";
        type = lib.types.str;
        description = ''
          Group that the CGI process will belong to. (Set to `config.services.gitolite.group` if you are using gitolite.)
        '';
      };

      virtualHost = lib.mkOption {
        default = "_";
        type = lib.types.str;
        description = ''
          VirtualHost to serve gitweb on. Default is catch-all.
        '';
      };
    };

  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "nginx" "gitweb" "enable" ]
      [ "services" "gitweb" "nginx" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nginx" "gitweb" "location" ]
      [ "services" "gitweb" "nginx" "location" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nginx" "gitweb" "user" ]
      [ "services" "gitweb" "nginx" "user" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nginx" "gitweb" "group" ]
      [ "services" "gitweb" "nginx" "group" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nginx" "gitweb" "virtualHost" ]
      [ "services" "gitweb" "nginx" "virtualHost" ]
    )
  ];

  config = lib.mkIf cfgNginx.enable {

    systemd.services.gitweb = {
      description = "GitWeb service";
      script = "${package}/gitweb.cgi --fastcgi --nproc=1";
      environment = {
        FCGI_SOCKET_PATH = "/run/gitweb/gitweb.sock";
      };
      serviceConfig = {
        User = cfgNginx.user;
        Group = cfgNginx.group;
        RuntimeDirectory = [ "gitweb" ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    services.nginx = {
      virtualHosts.${cfgNginx.virtualHost} = {
        locations."${cfgNginx.location}/static/" = {
          alias = "${package}/static/";
        };
        locations."${cfgNginx.location}/" = {
          extraConfig = ''
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_param GITWEB_CONFIG ${cfg.gitwebConfigFile};
            fastcgi_pass unix:/run/gitweb/gitweb.sock;
          '';
        };
      };
    };

  };

  meta.maintainers = [ ];

}
