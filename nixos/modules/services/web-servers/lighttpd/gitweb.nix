{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.gitweb;
  package = pkgs.gitweb.override (
    lib.optionalAttrs cfg.gitwebTheme {
      gitwebTheme = true;
    }
  );

in
{

  options.services.lighttpd.gitweb = {

    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        If true, enable gitweb in lighttpd. Access it at http://yourserver/gitweb
      '';
    };

  };

  config = lib.mkIf config.services.lighttpd.gitweb.enable {

    # declare module dependencies
    services.lighttpd.enableModules = [
      "mod_cgi"
      "mod_redirect"
      "mod_alias"
      "mod_setenv"
    ];

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
