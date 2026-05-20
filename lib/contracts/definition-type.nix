{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (types)
    attrs
    attrsOf
    functionTo
    listOf
    optionDeclaration
    optionType
    raw
    str
    submodule
    ;
in
submodule (contract: {
  options = {
    meta = mkOption {
      description = ''
        Useful information about the contract and its maintenance.
      '';
      type = submodule {
        options = {
          description = mkOption {
            description = ''
              Description of the contract.
            '';
            type = str;
          };
          maintainers = mkOption {
            description = ''
              Maintainers of the contract.
            '';
            type = listOf attrs;
          };
        };
      };
    };
    interface = mkOption {
      description = ''
        Interface describing the types used in the contract.
      '';
      default = { };
      type =
        let
          type = attrsOf optionDeclaration;
          default = { };
        in
        submodule {
          options = {
            request = mkOption {
              description = "Request type of the contract.";
              inherit type default;
            };
            result = mkOption {
              description = "Result type of the contract.";
              inherit type default;
            };
            extraImports = mkOption {
              description = "Extra imports for the request and result submodules (e.g. rename shims).";
              default = { };
              type = submodule {
                options = lib.genAttrs [ "request" "result" ] (
                  k:
                  mkOption {
                    description = "Extra imports for the ${k} submodule.";
                    type = listOf raw;
                    default = [ ];
                  }
                );
              };
            };
          };
        };
    };
    mkContract = mkOption {
      description = ''
        Augment the contract interface's type using a set of overrides.

        `contract.mkContract :: attrs -> optionType`

        **Inputs:**

        `overrides`

        : 1\. A (recursive) attrset of fields to add to the contract interface submodule type

        **Example:**

        ```nix
        { config, lib, ... }:
        let
          inherit (lib) mkOption contract types;
        in
        {
          options.foo = mkOption {
            default = { };
            type = config.contractType."<contract>".mkContract
              {
                bar = {
                  default = 10;
                  defaultText = "10";
                };
              };
          };
        }
        ```
      '';
      type = functionTo optionType;
      readOnly = true;
      default =
        overrides:
        let
          inherit (contract.config) interface;
        in
        lib.extendSubmodule overrides (submodule {
          options = lib.mapAttrs (
            k: options:
            mkOption {
              description = "The ${k} of the contract instance.";
              type = submodule {
                imports = interface.extraImports.${k};
                inherit options;
              };
            }
          ) (lib.getAttrs [ "request" "result" ] interface);
        });
    };
    behaviorTest = mkOption {
      description = ''
        Test used to ensure all `providers` of the contract behave the same way.

        For an example of how to write a test for a contract,
        see the `behaviorTest` in `lib/contracts/file-secrets.nix`.
      '';
      # The type should be more precise of course.
      # There should actually be a NixOSTest type.
      # And we can probably do something fancy with the `request` and `result` modules.
      type = functionTo attrs;
      default =
        {
          name,
          extraModules ? [ ],
        }:
        {
          name = "contracts_<contract>_${name}";
          containers.machine =
            { ... }:
            {
              imports = extraModules;
            };
          testScript =
            { ... }:
            ''
              machine.succeed("echo 'please define a test!' >&2; exit 1")
            '';
        };
      defaultText = lib.literalExpression ''
        {
          name,
          extraModules ? [ ],
        }:
        {
          name = "contracts_<contract>_''${name}";
          containers.machine =
            { ... }:
            {
              imports = extraModules;
            };
          testScript = { ... }: "";
        }
      '';
    };
  };
})
