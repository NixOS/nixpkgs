# Run:
#   nix-instantiate --eval nixos/modules/system/service/portable/test.nix
let
  lib = import ../../../../../lib;

  inherit (lib) mkOption types;

  portable-lib = import ./lib.nix { inherit lib; };

  configured = portable-lib.configure {
    serviceManagerPkgs = throw "do not use pkgs in this test";
    extraRootModules = [ ];
    extraRootSpecialArgs = { };
  };

  dummyPkg =
    name:
    derivation {
      system = "dummy";
      name = name;
      builder = "/bin/false";
    };

  exampleConfig = {
    _file = "${__curPos.file}:${toString __curPos.line}";
    services = {
      service1 = {
        process = {
          argv = [
            "/usr/bin/echo" # *giggles*
            "hello"
          ];
        };
        assertions = [
          {
            assertion = false;
            message = "you can't enable this for that reason";
          }
        ];
        warnings = [
          "The `foo' service is deprecated and will go away soon!"
        ];
      };
      service2 = {
        process = {
          # No meta.mainProgram, because it's supposedly an executable script _file_,
          # not a directory with a bin directory containing the main program.
          argv = [
            (dummyPkg "cowsay.sh")
            "world"
          ];
        };
      };
      service3 = {
        process = {
          argv = [ "/bin/false" ];
        };
        services.exclacow = {
          process = {
            argv = [
              (lib.getExe (
                dummyPkg "cowsay-ng"
                // {
                  meta.mainProgram = "cowsay";
                }
              ))
              "!"
            ];
          };
          assertions = [
            {
              assertion = false;
              message = "you can't enable this for such reason";
            }
          ];
          warnings = [
            "The `bar' service is deprecated and will go away soon!"
          ];
        };
      };
    };
  };

  exampleEval = lib.evalModules {
    modules = [
      {
        options.services = mkOption {
          type = types.attrsOf configured.serviceSubmodule;
        };
      }
      exampleConfig
    ];
  };

  filterEval =
    config:
    lib.optionalAttrs (config ? process) {
      inherit (config) assertions warnings process;
    }
    // {
      services = lib.mapAttrs (k: filterEval) config.services;
    };

  test =
    assert
      filterEval exampleEval.config == {
        services = {
          service1 = {
            process = {
              argv = [
                "/usr/bin/echo"
                "hello"
              ];
            };
            services = { };
            assertions = [
              {
                assertion = false;
                message = "you can't enable this for that reason";
              }
            ];
            warnings = [
              "The `foo' service is deprecated and will go away soon!"
            ];
          };
          service2 = {
            process = {
              argv = [
                "${dummyPkg "cowsay.sh"}"
                "world"
              ];
            };
            services = { };
            assertions = [ ];
            warnings = [ ];
          };
          service3 = {
            process = {
              argv = [ "/bin/false" ];
            };
            services.exclacow = {
              process = {
                argv = [
                  "${dummyPkg "cowsay-ng"}/bin/cowsay"
                  "!"
                ];
              };
              services = { };
              assertions = [
                {
                  assertion = false;
                  message = "you can't enable this for such reason";
                }
              ];
              warnings = [ "The `bar' service is deprecated and will go away soon!" ];
            };
            assertions = [ ];
            warnings = [ ];
          };
        };
      };

    assert
      portable-lib.getWarnings [ "service1" ] exampleEval.config.services.service1 == [
        "in service1: The `foo' service is deprecated and will go away soon!"
      ];

    assert
      portable-lib.getAssertions [ "service1" ] exampleEval.config.services.service1 == [
        {
          message = "in service1: you can't enable this for that reason";
          assertion = false;
        }
      ];

    assert
      portable-lib.getWarnings [ "service3" ] exampleEval.config.services.service3 == [
        "in service3.services.exclacow: The `bar' service is deprecated and will go away soon!"
      ];
    assert
      portable-lib.getAssertions [ "service3" ] exampleEval.config.services.service3 == [
        {
          message = "in service3.services.exclacow: you can't enable this for such reason";
          assertion = false;
        }
      ];

    "ok";

in
test
