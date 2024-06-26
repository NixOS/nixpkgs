{ nixosLib, pkgsModule, runCommand }:

let
  sys = nixosLib.evalModules rec {
    modules = [
      pkgsModule
      ../documentation.nix
      ../version.nix

      ({ lib, someArg, ... }: {
        # Make sure imports from specialArgs are respected
        imports = [ someArg.myModule ];

        # TODO test this
        meta.doc = ./test-dummy.chapter.xml;
      })

      {
        _module.args = {
          baseModules = [
            ../documentation.nix
            ../version.nix
          ];
          extraModules = [ ];
          inherit modules;
        };
        documentation.nixos.includeAllModules = true;
      }
    ];
    specialArgs.someArg.myModule = { lib, ... }: {
      options.foobar = lib.mkOption {
        type = lib.types.str;
        description = "The foobar option was added via specialArgs";
        default = "qux";
      };
    };
  };

in
runCommand "documentation-check"
{
  inherit (sys.config.system.build.manual) optionsJSON;
} ''
  json="$optionsJSON/share/doc/nixos/options.json"
  echo checking $json

  grep 'The foobar option was added via specialArgs' <"$json" >/dev/null
  touch $out
''
