{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
}:

let
  utils = import ../lib/utils.nix { inherit lib config pkgs; };

  writeSecretScript = name: value: ''
    mkdir -p /run/secrets
    touch /run/secrets/${name}
    chmod 700 /run/secrets/${name}
    echo "${value}" > /run/secrets/${name}
  '';

  aSecret = writeSecretScript "a-secret.txt" "Secret of A";
  bSecret = writeSecretScript "b-secret.txt" "Secret of B";
  eSecret = writeSecretScript "e-secret.txt" "prefix-abc";

  userConfig = {
    a.a._secret = "/run/secrets/a-secret.txt";
    b._secret = "/run/secrets/b-secret.txt";
    b.prefix = "prefix-";
    b.suffix = "-suffix";
    c = "not secret C";
    d.d = "not secret D";
    e._secret = "/run/secrets/e-secret.txt";
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
    replacePlaceholdersScriptJSON = rec {
      # Path with space on purpose!
      configLocation = "/var/lib/my config.json";

      inherit wantedConfig;

      nodeConfig = {
        system.activationScripts.genOutOfBand =
          pkgs.stringsWithDeps.stringAfter
            [
              "aSecret"
              "bSecret"
              "eSecret"
            ]
            (
              utils.replacePlaceholdersScript {
                sourceField = "_secret";
                fileWithPlaceholders = pkgs.writeText "config.yaml.template" (
                  lib.generators.toJSON { } (lib.replaceWithPlaceholder "_secret" userConfig)
                );
                inherit configLocation;
                replacements = lib.getPlaceholderReplacements "_secret" userConfig;
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    jsonFormat = rec {
      configLocation = "/var/lib/config.json";

      inherit wantedConfig;

      nodeConfig = {
        system.activationScripts.genOutOfBand =
          pkgs.stringsWithDeps.stringAfter
            [
              "aSecret"
              "bSecret"
              "eSecret"
            ]
            (
              utils.genConfigOutOfBand {
                config = userConfig;
                inherit configLocation;
                generator = utils.genConfigOutOfBandFormatAdapter (pkgs.formats.json { });
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    jsonGen = rec {
      configLocation = "/var/lib/config.json";

      inherit wantedConfig;

      nodeConfig = {
        system.activationScripts.genOutOfBand =
          pkgs.stringsWithDeps.stringAfter
            [
              "aSecret"
              "bSecret"
              "eSecret"
            ]
            (
              utils.genConfigOutOfBand {
                config = userConfig;
                inherit configLocation;
                generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    otherUserGroupTmpFiles = let
      configLocation = "/var/lib/outOfBandConfig/config.json";

      config = utils.genConfigOutOfBandSystemd {
        config = userConfig;
        inherit configLocation;
        generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
      };
    in {
      inherit configLocation wantedConfig;

      waitForUnit = "outOfBand.service";

      nodeConfig = {
        systemd.tmpfiles.rules = [ "d /var/lib/outOfBandConfig 0770 nobody nobody" ];
        systemd.services.outOfBand = {
          wantedBy = [ "sysinit.target" ];
          after = [ "sysinit.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;

          serviceConfig.User = "nobody";
          serviceConfig.Group = "nobody";
          serviceConfig.LoadCredential = config.loadCredentials;
          preStart = config.preStart;
          script = "cat ${configLocation}";
        };
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    otherUserGroupStateDirectory = let
      config = utils.genConfigOutOfBandSystemd {
        config = userConfig;
        configLocation = "$STATE_DIRECTORY/my config.json";
        generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
      };
    in {
      # Path with space on purpose!.
      # StateDirectory can't contain spaces.
      configLocation = "/var/lib/outOfBandConfig/my config.json";

      inherit wantedConfig;

      waitForUnit = "outOfBand.service";

      nodeConfig = {
        systemd.services.outOfBand = {
          wantedBy = [ "sysinit.target" ];
          after = [ "sysinit.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;

          serviceConfig.User = "nobody";
          serviceConfig.Group = "nobody";
          serviceConfig.StateDirectory = "outOfBandConfig";
          serviceConfig.LoadCredential = config.loadCredentials;
          preStart = config.preStart;
          script = "cat \"$STATE_DIRECTORY/my config.json\"";
        };
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    dynamicUser = let
      config = utils.genConfigOutOfBandSystemd {
        config = userConfig;
        configLocation = "$STATE_DIRECTORY/config.json";
        generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
      };
    in {
      configLocation = "/var/lib/private/outOfBandConfig/config.json";

      inherit wantedConfig;

      waitForUnit = "outOfBand.service";

      nodeConfig = {
        systemd.services.outOfBand = {
          wantedBy = [ "sysinit.target" ];
          after = [ "sysinit.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true; # Allows wait_for_unit to work.

          serviceConfig.DynamicUser = true;
          serviceConfig.StateDirectory = "outOfBandConfig";
          serviceConfig.LoadCredential = config.loadCredentials;
          preStart = config.preStart;
          script = ''
            echo $STATE_DIRECTORY/config.json
            cat $STATE_DIRECTORY/config.json
          '';
        };
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };
  };

  mkTest =
    name:
    {
      configLocation,
      wantedConfig,
      nodeConfig,
      pythonParseFile,
      waitForUnit ? null,
    }:
    import ./make-test-python.nix (
      { pkgs, ... }:
      {
        inherit name;
        meta.maintainers = with pkgs.lib.maintainers; [ ibizaman ];
        nodes.machine = lib.mkMerge [
          {
            system.activationScripts.aSecret = aSecret;
            system.activationScripts.bSecret = bSecret;
            system.activationScripts.eSecret = eSecret;
          }
          nodeConfig
        ];

        testScript =
          ''
            import json

            start_all()

            wantedConfig = json.loads('${lib.generators.toJSON { } wantedConfig}')

            machine.wait_for_file("${configLocation}")
          ''
          + (
            if waitForUnit == null then
              ""
            else
              ''
                machine.wait_for_unit("${waitForUnit}")
                print(machine.succeed("systemctl cat ${waitForUnit}"))
              ''
          )
          + ''
            print(machine.succeed("ls -l '${configLocation}'"))
            gotConfig = machine.succeed("cat '${configLocation}'")
            print(gotConfig)
            ${pythonParseFile}

            if wantedConfig != gotConfig:
              raise Exception("\nwantedConfig: {}\n!= gotConfig: {}".format(wantedConfig, gotConfig))

          '';
      }
    );
in

builtins.mapAttrs mkTest tests
