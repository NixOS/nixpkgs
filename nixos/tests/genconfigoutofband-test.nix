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
    replacePlaceholdersScriptJSON = {
      # Path with space on purpose!
      configs = {
        "/var/lib/my config.json" = wantedConfig;
      };

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
                configLocation = "/var/lib/my config.json";
                replacements = lib.getPlaceholderReplacements "_secret" userConfig;
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    jsonFormat = {
      configs = {
        "/var/lib/config.json" = wantedConfig;
      };

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
                configLocation = "/var/lib/config.json";
                generator = utils.genConfigOutOfBandFormatAdapter (pkgs.formats.json { });
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    jsonGen = {
      configs = {
        "/var/lib/config.json" = wantedConfig;
      };

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
                configLocation = "/var/lib/config.json";
                generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
              }
            );
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    otherUserGroupTmpFiles =
      let
        configLocation = "/var/lib/outOfBandConfig/config.json";

        config = utils.genConfigOutOfBandSystemd {
          config = userConfig;
          inherit configLocation;
          generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
        };
      in
      {
        configs = {
          ${configLocation} = wantedConfig;
        };

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

    otherUserGroupStateDirectoryManual =
      let
        config = utils.genConfigOutOfBandSystemd {
          config = userConfig;
          configLocation = "$STATE_DIRECTORY/my config.json";
          generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
        };
      in
      {
        # Path with space on purpose!.
        # StateDirectory can't contain spaces.
        configs = {
          "/var/lib/outOfBandConfig/my config.json" = wantedConfig;
        };

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
            script = ''
              echo "$STATE_DIRECTORY/my config.json"
              cat "$STATE_DIRECTORY/my config.json"
            '';
          };
        };

        pythonParseFile = ''
          gotConfig = json.loads(gotConfig)
        '';
      };

    otherUserGroupStateDirectoryModule = {
      # Path with space on purpose!.
      # StateDirectory can't contain spaces.
      configs = {
        "/var/lib/outOfBandConfig/my config.json" = wantedConfig;
      };

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
          outOfBandConfig = [
            {
              name = "my config.json";
              config = userConfig;
              generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
            }
          ];
          script = ''
            echo "$STATE_DIRECTORY/my config.json"
            cat "$STATE_DIRECTORY/my config.json"
          '';
        };
      };

      pythonParseFile = ''
        gotConfig = json.loads(gotConfig)
      '';
    };

    dynamicUserManual =
      let
        config = utils.genConfigOutOfBandSystemd {
          config = userConfig;
          configLocation = "$STATE_DIRECTORY/config.json";
          generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
        };
      in
      {
        configs = {
          "/var/lib/private/outOfBandConfig/config.json" = wantedConfig;
        };

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

    dynamicUserModule = {
      configs = {
        "/var/lib/outOfBandConfig/config.json" = wantedConfig;
      };

      waitForUnit = "outOfBand.service";

      nodeConfig = {
        systemd.services.outOfBand = {
          wantedBy = [ "sysinit.target" ];
          after = [ "sysinit.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true; # Allows wait_for_unit to work.

          serviceConfig.StateDirectory = "outOfBandConfig";
          outOfBandConfig = [
            {
              name = "config.json";
              config = userConfig;
              generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
            }
          ];
          serviceConfig.DynamicUser = true;
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

    multiConfigModule = {
      configs = {
        "/var/lib/outOfBandConfig/config1.json" = wantedConfig;
        "/var/lib/outOfBandConfig/config2.json" = {
          config2 = "Secret of A";
        };
      };

      waitForUnit = "outOfBand.service";

      nodeConfig = {
        systemd.services.outOfBand = {
          wantedBy = [ "sysinit.target" ];
          after = [ "sysinit.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true; # Allows wait_for_unit to work.

          serviceConfig.StateDirectory = "outOfBandConfig";
          outOfBandConfig = [
            {
              name = "config1.json";
              config = userConfig;
              generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
            }
            {
              name = "config2.json";
              config = {
                config2._secret = "/run/secrets/a-secret.txt";
              };
              generator = utils.genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON { });
            }
          ];
          script = ''
            echo $STATE_DIRECTORY/config1.json
            cat $STATE_DIRECTORY/config1.json
            echo $STATE_DIRECTORY/config2.json
            cat $STATE_DIRECTORY/config2.json
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
      configs,
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

          ''
          + (lib.concatStringsSep "\n" (
            lib.mapAttrsToList (c: _: ''
              machine.wait_for_file("${c}")
            '') configs
          ))
          + (
            if waitForUnit == null then
              ""
            else
              ''
                machine.wait_for_unit("${waitForUnit}")
                print(machine.succeed("systemctl cat ${waitForUnit}"))
              ''
          )
          + (lib.concatStringsSep "\n" (
            lib.mapAttrsToList (c: wantedConfig: ''
              print(machine.succeed("ls -l '${c}'"))
              gotConfig = machine.succeed("cat '${c}'")
              print(gotConfig)
              ${pythonParseFile}

              wantedConfig = json.loads('${lib.generators.toJSON { } wantedConfig}')

              if wantedConfig != gotConfig:
                raise Exception("\nwantedConfig: {}\n!= gotConfig: {}".format(wantedConfig, gotConfig))
            '') configs
          ));
      }
    );
in

builtins.mapAttrs mkTest tests
