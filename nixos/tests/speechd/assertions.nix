{ lib, pkgs, ... }:

let
  evalSpeechd =
    extraConfig:
    (import ../../lib/eval-config.nix {
      inherit lib;
      system = pkgs.stdenv.hostPlatform.system;
      modules = [
        extraConfig
        {
          fileSystems."/" = {
            device = "/dev/sda1";
            fsType = "ext4";
          };
          boot.loader.grub.device = "/dev/sda";
        }
      ];
    }).config;

  hasFailingAssertion =
    needle: cfg: lib.any (a: !a.assertion && lib.hasInfix needle a.message) cfg.assertions;

  allAssertionsPass =
    cfg:
    let
      failing = lib.filter (a: !a.assertion) cfg.assertions;
    in
    if failing == [ ] then
      true
    else
      lib.trace (lib.concatMapStringsSep "\n" (a: "FAILED ASSERTION: ${a.message}") failing) false;

in
lib.runTests {

  testCleanConfigHasNoAssertions = {
    expr = allAssertionsPass (evalSpeechd {
      services.speechd.enable = true;
    });
    expected = true;
  };

  testDefaultModuleValidNoAssertion = {
    expr = allAssertionsPass (evalSpeechd {
      services.speechd = {
        enable = true;
        modules.pico.enable = true;
        defaultModule = "pico";
      };
    });
    expected = true;
  };

  testModuleExtraModuleCollision = {
    expr = hasFailingAssertion "is a predefined module in `services.speechd" (evalSpeechd {
      services.speechd = {
        enable = true;
        extraModules.pico = "Debug 0";
      };
    });
    expected = true;
  };

  testModuleExtraModuleCollisionEvenWhenEnabled = {
    expr = hasFailingAssertion "is a predefined module in `services.speechd" (evalSpeechd {
      services.speechd = {
        enable = true;
        modules.pico.enable = true;
        extraModules.pico = "Debug 0";
      };
    });
    expected = true;
  };

  testModuleExtraConfigAddModuleCollisionWithEnabledModule = {
    expr =
      hasFailingAssertion ''services.speechd.extraConfig contains an AddModule directive for "''
        (evalSpeechd {
          services.speechd = {
            enable = true;
            modules.espeakNg.enable = true;
            extraConfig = ''
              AddModule "espeakNg" "sd_espeak-ng" "espeak-ng.conf"
            '';
          };
        });
    expected = true;
  };

  testModuleExtraConfigAddModuleCollisionWithDisabledModule = {
    expr =
      hasFailingAssertion ''services.speechd.extraConfig contains an AddModule directive for "''
        (evalSpeechd {
          services.speechd = {
            enable = true;
            modules.pico.enable = false;
            extraConfig = ''
              AddModule "pico" "sd_pico"      "pico.conf"
            '';
          };
        });
    expected = true;
  };

  testModuleExtraConfigAddModuleCollisionWithDisabledModuleExtraWhiteSpace = {
    expr =
      hasFailingAssertion ''services.speechd.extraConfig contains an AddModule directive for "''
        (evalSpeechd {
          services.speechd = {
            enable = true;
            modules.pico.enable = false;
            extraConfig = ''
              AddModule                       "pico" "sd_pico"      "pico.conf"
            '';
          };
        });
    expected = true;
  };

  testModuleExtraConfigAddModuleCollisionWithExtraModule = {
    expr =
      hasFailingAssertion ''services.speechd.extraConfig contains an AddModule directive for "''
        (evalSpeechd {
          services.speechd = {
            enable = true;
            extraModules.myModules = ''Debug "1"'';
            extraConfig = ''
              AddModule "mymodules" "sd_generic"  "myModules.conf"
            '';
          };
        });
    expected = false;
  };

  testDefaultModuleUnknown = {
    expr =
      hasFailingAssertion
        ''
          but it
          does not match the attribute name of an enabled module under
          services.speechd.modules, nor a key in services.speechd.extraModules.
        ''
        (evalSpeechd {
          services.speechd = {
            enable = true;
            defaultModule = "does-not-exist";
          };
        });
    expected = true;
  };

  testUnrecognizedBackendName = {
    expr =
      hasFailingAssertion "services.speechd.modules contains unrecognized backend name(s):"
        (evalSpeechd {
          services.speechd = {
            enable = true;
            modules.doesNotExist.enable = true;
          };
        });
    expected = true;
  };

  testExtraConfigLogLevelDirective = {
    expr = hasFailingAssertion "services.speechd.extraConfig contains a" (evalSpeechd {
      services.speechd = {
        enable = true;
        extraConfig = "LogLevel 5\n";
      };
    });
    expected = true;
  };
}
