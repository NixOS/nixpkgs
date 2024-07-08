{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.languagetool;
  settingsFormat = pkgs.formats.javaProperties { };
in
{
  options.services.languagetool = {
    enable = mkEnableOption "the LanguageTool server, a multilingual spelling, style, and grammar checker that helps correct or paraphrase texts";

    package = mkPackageOption pkgs "languagetool" { };

    port = mkOption {
      type = types.port;
      default = 8081;
      example = 8081;
      description = ''
        Port on which LanguageTool listens.
      '';
    };

    public = mkEnableOption "access from anywhere (rather than just localhost)";

    allowOrigin = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "https://my-website.org";
      description = ''
        Set the Access-Control-Allow-Origin header in the HTTP response,
        used for direct (non-proxy) JavaScript-based access from browsers.
        `null` to allow access from all sites.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options.cacheSize = mkOption {
          type = types.ints.unsigned;
          default = 1000;
          apply = toString;
          description = "Number of sentences cached.";
        };
      };
      default = {};
      description = ''
        Configuration file options for LanguageTool, see
        'languagetool-http-server --help'
        for supported settings.
      '';
    };

    jrePackage = mkPackageOption pkgs "jre" { };

    jvmOptions = mkOption {
      description = ''
        Extra command line options for the JVM running languagetool.
        More information can be found here: https://docs.oracle.com/en/java/javase/19/docs/specs/man/java.html#standard-options-for-java
      '';
      default = [ ];
      type = types.listOf types.str;
      example = [
        "-Xmx512m"
      ];
    };
  };

  config = mkIf cfg.enable {

    systemd.services.languagetool = {
      description = "LanguageTool HTTP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        DynamicUser = true;
        User = "languagetool";
        Group = "languagetool";
        CapabilityBoundingSet = [ "" ];
        RestrictNamespaces = [ "" ];
        SystemCallFilter = [ "@system-service" "~ @privileged" ];
        ProtectHome = "yes";
        Restart = "on-failure";
        ExecStart = ''
          ${cfg.jrePackage}/bin/java \
            -cp ${cfg.package}/share/languagetool-server.jar \
            ${toString cfg.jvmOptions} \
            org.languagetool.server.HTTPServer \
              --port ${toString cfg.port} \
              ${optionalString cfg.public "--public"} \
              ${optionalString (cfg.allowOrigin != null) "--allow-origin ${cfg.allowOrigin}"} \
              "--config" ${settingsFormat.generate "languagetool.conf" cfg.settings}
        '';
      };
    };
  };
}
