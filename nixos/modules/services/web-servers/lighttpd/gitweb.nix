{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.lighttpd.gitweb;
  gitwebConfigFile = pkgs.writeText "gitweb.conf" ''
    # path to git projects (<project>.git)
    $projectroot = "${cfg.projectroot}";
    ${cfg.extraConfig}
  '';

in
{

  options.services.lighttpd.gitweb = {

    enable = mkOption {
      default = false;
      type = types.uniq types.bool;
      description = ''
        If true, enable gitweb in lighttpd. Access it at http://yourserver/gitweb
      '';
    };

    projectroot = mkOption {
      default = "/srv/git";
      type = types.str;
      description = ''
        Path to git projects (bare repositories) that should be served by
        gitweb. Must not end with a slash.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.str;
      description = ''
        Verbatim configuration text appended to the generated gitweb.conf file.
      '';
    };

  };

  config = mkIf cfg.enable {

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/gitweb" {
          cgi.assign = (
              ".cgi" => "${pkgs.perl}/bin/perl"
          )
          url.redirect = (
              "^/gitweb$" => "/gitweb/"
          )
          alias.url = (
              "/gitweb/static/" => "${pkgs.git}/share/gitweb/static/",
              "/gitweb/"        => "${pkgs.git}/share/gitweb/gitweb.cgi"
          )
          setenv.add-environment = (
              "GITWEB_CONFIG" => "${gitwebConfigFile}"
          )
      }
    '';

  };

}
