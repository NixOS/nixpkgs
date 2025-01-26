{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.languagetool;
  settingsFormat = pkgs.formats.javaProperties { };
in
{
  options.services.languagetool = {
    enable = lib.mkEnableOption "the LanguageTool server, a multilingual spelling, style, and grammar checker that helps correct or paraphrase texts";

    package = lib.mkPackageOption pkgs "languagetool" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      example = 8081;
      description = ''
        Port on which LanguageTool listens.
      '';
    };

    public = lib.mkEnableOption "access from anywhere (rather than just localhost)";

    allowOrigin = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "https://my-website.org";
      description = ''
        Set the Access-Control-Allow-Origin header in the HTTP response,
        used for direct (non-proxy) JavaScript-based access from browsers.
        `"*"` to allow access from all sites.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options.cacheSize = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 1000;
          apply = toString;
          description = "Number of sentences cached.";
        };
      };
      default = { };
      description = ''
        Configuration file options for LanguageTool, see
        'languagetool-http-server --help'
        for supported settings.
      '';
    };

    jrePackage = lib.mkPackageOption pkgs "jre" { };

    jvmOptions = lib.mkOption {
      description = ''
        Extra command line options for the JVM running languagetool.
        More information can be found here: https://docs.oracle.com/en/java/javase/19/docs/specs/man/java.html#standard-options-for-java
      '';
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [
        "-Xmx512m"
      ];
    };
  };

  config = lib.mkIf cfg.enable {

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
        SystemCallFilter = [
          "@system-service"
          "~ @privileged"
        ];
        ProtectHome = "yes";
        Restart = "on-failure";
        ExecStart = ''
          ${cfg.jrePackage}/bin/java \
            -cp ${cfg.package}/share/languagetool-server.jar \
            ${toString cfg.jvmOptions} \
            org.languagetool.server.HTTPServer \
              --port ${toString cfg.port} \
              ${lib.optionalString cfg.public "--public"} \
              ${lib.optionalString (cfg.allowOrigin != null) "--allow-origin ${cfg.allowOrigin}"} \
              "--config" ${settingsFormat.generate "languagetool.conf" cfg.settings}
        '';
      };
    };
  };
}
