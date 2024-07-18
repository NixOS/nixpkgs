{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, lib ? pkgs.lib
, testing ? import ../lib/testing-python.nix { inherit system pkgs; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  utils = import ../lib/utils.nix { inherit lib config pkgs; };

  aSecret = pkgs.writeText "a-secret.txt" "Secret of A";
  bSecret = pkgs.writeText "b-secret.txt" "Secret of B";
  eSecret = pkgs.writeText "e-secret.txt" "prefix-abc";

  userConfig = {
    a.a._secret = aSecret;
    b._secret = bSecret;
    b.prefix = "prefix-";
    b.suffix = "-suffix";
    c = "not secret C";
    d.d = "not secret D";
    e._secret = eSecret;
    e.prefixIfNotPresent = "prefix-";
    e.suffixIfNotPresent = "-suffix";
  };

  wantedConfig = {
    a.a = "Secret of A";
    b = "prefix-Secret of B-suffix";
    c = "not secret C";
    d.d = "not secret D";
    e = "prefix-abc-suffix";
  };

  tests = {
    replacePlaceholdersScriptJSONTest = rec {
      configLocation = "/var/lib/config.json";

      inherit wantedConfig;

      script = utils.replacePlaceholdersScript {
        sourceField = "_secret";
        fileWithPlaceholders = pkgs.writeText "config.yaml.template"
          (lib.generators.toJSON {} (lib.replaceWithPlaceholder "_secret" userConfig));
        inherit configLocation;
        replacements = lib.getPlaceholderReplacements "_secret" userConfig;
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    genConfigOutOfBandJSONFormat = rec {
      configLocation = "/var/lib/config.json";

      inherit wantedConfig;

      script = utils.genConfigOutOfBand {
        config = userConfig;
        inherit configLocation;
        generator = utils.genConfigOutOfBandFormatAdapter (pkgs.formats.json {});
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    genConfigOutOfBandJSONGen = rec {
      configLocation = "/var/lib/config.json";

      inherit wantedConfig;

      script = utils.genConfigOutOfBand {
        config = userConfig;
        inherit configLocation;
        generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON {});
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };
  };

  mkTest = name: { configLocation, wantedConfig, script, pythonParseFile }:
    import ./make-test-python.nix ({ pkgs, ... }: {
      inherit name;
      meta.maintainers = with pkgs.lib.maintainers; [ ibizaman ];
      nodes.machine = {
        system.activationScripts.genOutOfBand = script;
      };

      testScript = ''
        import json

        start_all()

        wantedConfig = json.loads('${lib.generators.toJSON {} wantedConfig}')

        machine.wait_for_file("${configLocation}")
        print(machine.succeed("cat ${pkgs.writeText "replaceInTemplate" script}"))

        gotConfig = machine.succeed("cat ${configLocation}")
        print(gotConfig)
        ${pythonParseFile}

        if wantedConfig != gotConfig:
          raise Exception("\nwantedConfig: {}\n!= gotConfig: {}".format(wantedConfig, gotConfig))

      '';
    });
in

builtins.mapAttrs (k: v: mkTest k v) tests
