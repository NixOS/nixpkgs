{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.fossil;
in
{

  ###### interface

  options.services.fossil = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Enable the Fossil server, which will start an HTTP server to
          publish Fossil repositories.
        '';
    };

    repository = mkOption {
      type = types.str;
      default = "/srv/fossil";
      example = "/fossils/repo.fossil";
      description = ''
          The REPOSITORY can be a directory that contains one or more
          repositories with names ending in ".fossil" or a single file.
        '';
    };

    baseurl = mkOption {
      type = types.str;
      default = "";
      example = "example.com";
      description = "Use URL as the base (useful for reverse proxies)";
    };

    extroot = mkOption {
      type = types.str;
      default = "";
      description = "Document root for the /ext extension mechanism";
    };

    files = mkOption {
      type = types.str;
      default = "";
      description = "Comma-separated list of glob patterns for static files";
    };

    https = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Indicates that the input is coming through a reverse proxy
          that has already translated HTTPS into HTTP.
        '';
    };

    jsmode = mkOption {
      type = types.str;
      default = "";
      example = "inline";
      description = ''
          Determine how JavaScript is delivered with pages.
          Mode can be one of:
            inline       All JavaScript is inserted inline at
                         the end of the HTML file.
            separate     Separate HTTP requests are made for
                         each JavaScript file.
            bundled      One single separate HTTP fetches all
                         JavaScript concatenated together.
        '';
    };

    maxLatency = mkOption {
      type = types.int;
      default = 0;
      example = 60;
      description = "Do not let any single HTTP request run for more than N seconds";
    };

    nocompress = mkOption {
      type = types.bool;
      default = false;
      description = "Do not compress HTTP replies";
    };

    nojail = mkOption {
      type = types.bool;
      default = false;
      description = "Drop root privileges but do not enter the chroot jail";
    };

    nossl = mkOption {
      type = types.bool;
      default = false;
      description = "Signal that no SSL connections are available";
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "Port to listen on";
    };

    repolist = mkOption {
      type = types.bool;
      default = if (lib.strings.hasSuffix ".fossil" cfg.repository) then false else true;
      description = ''If REPOSITORY is dir, URL "/" lists repos.'';
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    systemd.services.fossil = {
      preStart = if lib.strings.hasSuffix ".fossil" cfg.repository
                 then ""
                 else  ''
                   if [ ! -d ${cfg.repository} ]; then
                     mkdir -pv ${cfg.repository};
                   fi
                 '';
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.fossil}/bin/fossil server "
        + (optionalString (cfg.baseurl != "") "--baseurl ${cfg.baseurl} ")
        + (optionalString (cfg.extroot != "") "--extroot ${cfg.extroot} ")
        + (optionalString (cfg.files != "") "--files ${cfg.files} ")
        + (optionalString (cfg.jsmode != "") "--jsmode  ${cfg.jsmode} ")
        + (optionalString (cfg.maxLatency > 0) "--max-latency  ${toString cfg.maxLatency} ")
        + (optionalString cfg.nocompress "--nocompress ")
        + (optionalString cfg.https "--https ")
        + (optionalString cfg.nojail "--nojail ")
        + (optionalString cfg.nossl "--nossl ")
        + (optionalString cfg.repolist "--repolist ")
        + "--port ${toString cfg.port} "
        + cfg.repository;
    };

  };

}
