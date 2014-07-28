{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lighttpd.cgit;
  configFile = pkgs.writeText "cgitrc"
    ''
      ${cfg.configText}
    '';
in
{

  options.services.lighttpd.cgit = {

    enable = mkOption {
      default = false;
      type = types.uniq types.bool;
      description = ''
        If true, enable cgit (fast web interface for git repositories) as a
        sub-service in lighttpd. cgit will be accessible at
        http://yourserver/cgit
      '';
    };

    configText = mkOption {
      default = "";
      example = ''
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

  };

  config = mkIf cfg.enable {

    # make the cgitrc manpage available
    environment.systemPackages = [ pkgs.cgit ];

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/cgit" {
          cgi.assign = (
              "cgit.cgi" => "${pkgs.cgit}/cgit/cgit.cgi"
          )
          alias.url = (
              "/cgit.css" => "${pkgs.cgit}/cgit/cgit.css",
              "/cgit.png" => "${pkgs.cgit}/cgit/cgit.png",
              "/cgit"     => "${pkgs.cgit}/cgit/cgit.cgi"
          )
          setenv.add-environment = (
              "CGIT_CONFIG" => "${configFile}"
          )
      }
    '';

  };

}
