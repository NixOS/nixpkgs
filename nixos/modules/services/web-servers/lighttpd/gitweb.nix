{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitweb;
  package = pkgs.gitweb.override (optionalAttrs cfg.gitwebTheme {
    gitwebTheme = true;
  });

in
{

  options.services.lighttpd.gitweb = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable gitweb in lighttpd. Access it at http://yourserver/gitweb
      '';
    };

  };

  config = mkIf config.services.lighttpd.gitweb.enable {

    # declare module dependencies
    services.lighttpd.enableModules = [ "mod_cgi" "mod_redirect" "mod_alias" "mod_setenv" ];

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/gitweb" {
          cgi.assign = (
              ".cgi" => "${pkgs.perl}/bin/perl"
          )
          url.redirect = (
              "^/gitweb$" => "/gitweb/"
          )
          alias.url = (
              "/gitweb/static/" => "${package}/static/",
              "/gitweb/"        => "${package}/gitweb.cgi"
          )
          setenv.add-environment = (
              "GITWEB_CONFIG" => "${cfg.gitwebConfigFile}",
              "HOME" => "${cfg.projectroot}"
          )
      }
    '';

  };

}
