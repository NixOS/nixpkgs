# Run:
#   nix-instantiate --eval lib/services/test.nix
let
  lib = import ../.;

  inherit (lib) mkOption types;

  portable-lib = lib.services;

  dummyPkg =
    name:
    derivation {
      system = "dummy";
      name = name;
      builder = "/bin/false";
    };

  configured = portable-lib.configure {
    # `coreutils` is the only package the portable layer legitimately needs, to derive
    # `process.reloadCommand` from `process.reloadSignal`. Anything else reaching for
    # `pkgs` fails on the missing attribute.
    serviceManagerPkgs = {
      coreutils = dummyPkg "coreutils";
    };
    extraRootModules = [ ];
    extraRootSpecialArgs = { };
  };

  exampleConfig = {
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
          reloadCommand = "${dummyPkg "cowsay.sh"} reload";
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
            reloadSignal = "HUP";
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
      # The default `flagFormat`, and one flag of every supported value kind.
      flagsDefault = {
        process = {
          argv = [ "/bin/flagged" ];
          flags = {
            "--bool-off" = false;
            "--bool-on" = true;
            "--config" = ./test.nix;
            "--count" = 3;
            "--name" = "example";
            "--unset" = null;
          };
        };
      };
      # A `flagFormat` that joins with `=` and spells out booleans.
      flagsCustomFormat = {
        process = {
          argv = [ "/bin/flagged" ];
          flagFormat = name: {
            option = "--${name}";
            sep = "=";
            explicitBool = true;
          };
          flags = {
            port = 8080;
            quiet = false;
            verbose = true;
          };
        };
      };
      # The list form, which allows a flag to be repeated.
      flagsRepeated = {
        process = {
          argv = [ "/bin/flagged" ];
          flags = [
            { "--host" = "a"; }
            { "--host" = "b"; }
          ];
        };
      };
      # `argv` and `flags` share one `lib.mkOrder` space.
      flagsOrdering = {
        process = {
          argv = lib.mkMerge [
            (lib.mkBefore [ "/bin/gt" ])
            (lib.mkOrder 800 [ "server" ])
            (lib.mkAfter [ "TRAILING" ])
          ];
          flags = lib.mkMerge [
            { "--listen" = "a"; }
            { "--disable-landlock" = lib.mkOrder 600 true; }
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

  # Every service carries some assertions that hold; only the violated ones are of interest here.
  failures = lib.filter (a: !a.assertion);

  # The goal of this test is to perform and check a complete evaluation of all options.
  # Only filter out values that are truly infeasible to check, such as function values.
  filterEval =
    config:
    lib.optionalAttrs (config ? process) {
      inherit (config) warnings;
      assertions = failures config.assertions;
      # `flagFormat` is a function and cannot be compared; the rest of `process` is checked.
      process = { inherit (config.process) argv reloadCommand reloadSignal; };
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
              reloadCommand = null;
              reloadSignal = null;
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
              reloadCommand = "${dummyPkg "cowsay.sh"} reload";
              reloadSignal = null;
            };
            services = { };
            assertions = [ ];
            warnings = [ ];
          };
          service3 = {
            process = {
              argv = [ "/bin/false" ];
              reloadCommand = null;
              reloadSignal = null;
            };
            services.exclacow = {
              process = {
                argv = [
                  "${dummyPkg "cowsay-ng"}/bin/cowsay"
                  "!"
                ];
                reloadCommand = "${dummyPkg "coreutils"}/bin/kill -HUP $MAINPID";
                reloadSignal = "HUP";
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
          flagsDefault = {
            process = {
              argv = [
                "/bin/flagged"
                "--bool-on"
                "--config"
                "${./test.nix}"
                "--count"
                "3"
                "--name"
                "example"
              ];
              reloadCommand = null;
              reloadSignal = null;
            };
            services = { };
            assertions = [ ];
            warnings = [ ];
          };
          flagsCustomFormat = {
            process = {
              argv = [
                "/bin/flagged"
                "--port=8080"
                "--quiet=false"
                "--verbose=true"
              ];
              reloadCommand = null;
              reloadSignal = null;
            };
            services = { };
            assertions = [ ];
            warnings = [ ];
          };
          flagsRepeated = {
            process = {
              argv = [
                "/bin/flagged"
                "--host"
                "a"
                "--host"
                "b"
              ];
              reloadCommand = null;
              reloadSignal = null;
            };
            services = { };
            assertions = [ ];
            warnings = [ ];
          };
          flagsOrdering = {
            process = {
              argv = [
                "/bin/gt"
                "--disable-landlock"
                "server"
                "--listen"
                "a"
                "TRAILING"
              ];
              reloadCommand = null;
              reloadSignal = null;
            };
            services = { };
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
      failures (portable-lib.getAssertions [ "service1" ] exampleEval.config.services.service1) == [
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
      failures (portable-lib.getAssertions [ "service3" ] exampleEval.config.services.service3) == [
        {
          message = "in service3.services.exclacow: you can't enable this for such reason";
          assertion = false;
        }
      ];

    "ok";

in
test
