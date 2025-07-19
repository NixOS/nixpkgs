# Run:
#   nix-instantiate --eval nixos/modules/system/service/portable/test.nix
let
  lib = import ../../../../../lib;

  inherit (lib) mkOption types;

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
          executable = "/usr/bin/echo"; # *giggles*
          args = [ "hello" ];
        };
      };
      service2 = {
        process = {
          # No meta.mainProgram, because it's supposedly an executable script _file_,
          # not a directory with a bin directory containing the main program.
          executable = dummyPkg "cowsay.sh";
          args = [ "world" ];
        };
      };
      service3 = {
        process = {
          executable = dummyPkg "cowsay-ng" // {
            meta.mainProgram = "cowsay";
          };
          args = [ "!" ];
        };
      };
    };
  };

  exampleEval = lib.evalModules {
    modules = [
      {
        options.services = mkOption {
          type = types.attrsOf (
            types.submoduleWith {
              class = "service";
              modules = [
                ./service.nix
              ];
            }
          );
        };
      }
      exampleConfig
    ];
  };

  test =
    assert
      exampleEval.config == {
        services = {
          service1 = {
            process = {
              executable = "/usr/bin/echo";
              args = [ "hello" ];
            };
            services = { };
          };
          service2 = {
            process = {
              executable = "${dummyPkg "cowsay.sh"}";
              args = [ "world" ];
            };
            services = { };
          };
          service3 = {
            process = {
              executable = "${dummyPkg "cowsay-ng"}/bin/cowsay";
              args = [ "!" ];
            };
            services = { };
          };
        };
      };

    "ok";

in
test
