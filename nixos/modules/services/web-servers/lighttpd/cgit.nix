{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.lighttpd.cgit;
  pathPrefix = optionalString (stringLength cfg.subdir != 0) ("/" + cfg.subdir);
  configFile = pkgs.writeText "cgitrc" ''
    # default paths to static assets
    css=${pathPrefix}/cgit.css
    logo=${pathPrefix}/cgit.png
    favicon=${pathPrefix}/favicon.ico

    # user configuration
    ${cfg.configText}
  '';
in
{

  options.services.lighttpd.cgit = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable cgit (fast web interface for git repositories) as a
        sub-service in lighttpd.
      '';
    };

    subdir = mkOption {
      default = "cgit";
      example = "";
      type = types.str;
      description = ''
        The subdirectory in which to serve cgit. The web application will be
        accessible at http://yourserver/''${subdir}
      '';
    };

    configText = mkOption {
      default = "";
      example = literalExpression ''
        '''
          source-filter=''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
          about-filter=''${pkgs.cgit}/lib/cgit/filters/about-formatting.sh
          cache-size=1000
          scan-path=/srv/git
        '''
      '';
      type = types.lines;
      description = ''
        Verbatim contents of the cgit runtime configuration file. Documentation
        (with cgitrc example file) is available in "man cgitrc". Or online:
        <http://git.zx2c4.com/cgit/tree/cgitrc.5.txt>
      '';
    };

  };

  config = mkIf cfg.enable {

    # make the cgitrc manpage available
    environment.systemPackages = [ pkgs.cgit ];

    # declare module dependencies
    services.lighttpd.enableModules = [
      "mod_cgi"
      "mod_alias"
      "mod_setenv"
    ];

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/${cfg.subdir}" {
          cgi.assign = (
              "cgit.cgi" => "${pkgs.cgit}/cgit/cgit.cgi"
          )
          alias.url = (
              "${pathPrefix}/cgit.css" => "${pkgs.cgit}/cgit/cgit.css",
              "${pathPrefix}/cgit.png" => "${pkgs.cgit}/cgit/cgit.png",
              "${pathPrefix}"          => "${pkgs.cgit}/cgit/cgit.cgi"
          )
          setenv.add-environment = (
              "CGIT_CONFIG" => "${configFile}"
          )
      }
    '';

    systemd.services.lighttpd.preStart = ''
      mkdir -p /var/cache/cgit
      chown lighttpd:lighttpd /var/cache/cgit
    '';

  };

}
