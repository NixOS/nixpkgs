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

    n-grams =
      let
        mkNGramsLangModule =
          {
            language,
            url,
            hash,
          }:
          {
            enable = lib.mkEnableOption "${language} n-gram data";
            package = lib.mkOption {
              description = "The ${language} n-gram data package.";
              type = lib.types.package;
              default = pkgs.fetchzip { inherit url hash; };
              defaultText = lib.literalExpression ''
                pkgs.fetchzip {
                  url = "${url}";
                  hash = "${hash}";
                }
              '';
            };
          };
      in
      {
        de = mkNGramsLangModule {
          language = "German";
          url = "https://languagetool.org/download/ngram-data/ngrams-de-20150819.zip";
          hash = "sha256-b+dPqDhXZQpVOGwDJOO4bFTQ15hhOSG6WPCx8RApfNg=";
        };
        en = mkNGramsLangModule {
          language = "English";
          url = "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
          hash = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
        };
        es = mkNGramsLangModule {
          language = "Spanish";
          url = "https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip";
          hash = "sha256-mA2dFEscDNr4tJQzQnpssNAmiSpd9vaDX8e+21OJUgQ=";
        };
        fr = mkNGramsLangModule {
          language = "French";
          url = "https://languagetool.org/download/ngram-data/ngrams-fr-20150913.zip";
          hash = "sha256-z+JJe8MeI9YXE2wUA2acK9SuQrMZ330QZCF9e234FCk=";
        };
        nl = mkNGramsLangModule {
          language = "Dutch";
          url = "https://languagetool.org/download/ngram-data/ngrams-nl-20181229.zip";
          hash = "sha256-bHOEdb2R7UYvXjqL7MT4yy3++hNMVwnG7TJvvd3Feg8=";
        };
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

    jvmOptions = lib.mkOption {
      description = ''
        Extra command line options for the JVM running languagetool.
        More information can be found here: <https://docs.oracle.com/en/java/javase/19/docs/specs/man/java.html#standard-options-for-java>
      '';
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [
        "-Xmx512m"
      ];
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "languagetool"
      "jrePackage"
    ] "The jre is now always taken from the package's jre attribute.")
  ];

  config = {
    services.languagetool.settings.languageModel =
      let
        enabledNGrams = lib.filterAttrs (_: v: v.enable) cfg.n-grams;
        buildCommand = lib.concatLines (
          [ "mkdir $out" ] ++ lib.mapAttrsToList (n: v: "ln -s ${v.package} $out/${n}") enabledNGrams
        );
      in
      lib.mkIf (enabledNGrams != { }) (pkgs.runCommand "languagetool_n-grams" { } buildCommand);

    systemd.services.languagetool = lib.mkIf cfg.enable {
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
        ExecStart = lib.concatStringsSep " " (
          [
            (lib.getExe cfg.package.jre)
            "-cp ${cfg.package}/share/languagetool-server.jar"
            (lib.escapeShellArgs cfg.jvmOptions)
            "org.languagetool.server.HTTPServer"
            "--config ${settingsFormat.generate "languagetool.conf" cfg.settings}"
            "--port ${toString cfg.port}"
          ]
          ++ lib.optional cfg.public "--public"
          ++ lib.optional (cfg.allowOrigin != null) "--allow-origin ${lib.escapeShellArg cfg.allowOrigin}"
        );
      };
    };
  };
}
