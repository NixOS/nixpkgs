{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx.cgit;
  configFile = pkgs.writeText "cgitrc"
    ''
      css=/cgit.css
      logo=/cgit.png
      favicon=/favicon.ico

      # user configuration
      ${cfg.configText}
    '';
in
{

  options.services.nginx.cgit = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable cgit (fast web interface for git repositories) as a
        sub-service in nginx.
      '';
    };

    location = mkOption {
      default = "/";
      type = types.str;
      description = ''
        Location to serve cgit on.
      '';
    };

    configText = mkOption {
      default = "";
      example = ''
        virtual-root=/
        source-filter=''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
        about-filter=''${pkgs.cgit}/lib/cgit/filters/about-formatting.sh
        cache-size=1000
        scan-path=/srv/git
      '';
      type = types.lines;
      description = ''
        Verbatim contents of the cgit runtime configuration file. Documentation
        (with cgitrc example file) is available in "man cgitrc". Or online:
        http://git.zx2c4.com/cgit/tree/cgitrc.5.txt
      '';
    };

    virtualHost = mkOption {
      default = "_";
      type = types.str;
      description = ''
        VirtualHost to serve cgit on. Default is catch-all.
      '';
    };

  };

  config = mkIf cfg.enable {

    # make the cgitrc manpage available
    environment.systemPackages = [ pkgs.cgit ];

    services.fcgiwrap.enable = true;

    services.nginx = {
      virtualHosts.${cfg.virtualHost} = {
        locations."${cfg.location}" = {
          extraConfig =
          ''
            gzip off;
            root ${pkgs.cgit}/cgit/;
            try_files   $uri @cgit;
          '';
        };
        locations."~* ^/(cgit.(css|png)|favicon.ico|robots.txt)" = {
          root = "${pkgs.cgit}/cgit/";
        };
        locations."@cgit" = {
          extraConfig =
            let pathInfo = if cfg.location == "/"
              then
              ''
                fastcgi_param   PATH_INFO   $uri;
              ''
              else
              ''
                fastcgi_split_path_info  ^(${cfg.location}/)(/?.+)$;
                fastcgi_param  PATH_INFO  $fastcgi_path_info;
              '';
            in
            ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_param   CGIT_CONFIG     ${configFile};
              fastcgi_param   SCRIPT_FILENAME ${pkgs.cgit}/cgit/cgit.cgi;
              fastcgi_param   QUERY_STRING    $args;
              fastcgi_param   HTTP_HOST       $server_name;
              fastcgi_pass    unix:/run/fcgiwrap.socket;
            '' + pathInfo;
        };
      };
    };

  };

}
