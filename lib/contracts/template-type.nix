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
    mkProviderType = mkOption {
      description = ''
        Create a `nestedAttrsOf` type for provider instances with automatic result computation.

        Reduces provider boilerplate by combining request/result option declarations
        and optional result derivation into a single type constructor.

        `<contract>.mkProviderType :: { providerOptions?, overrides?, fulfill?, fulfill'? } -> optionType`

        **Inputs:**

        `overrides`

        : 1\. Overrides for `{ request, result }` submodule types (to e.g. add defaults)

        `providerOptions`

        : 2\. Additional option declarations of the provider outside of the contract's request/result.

        `fulfill`

        : 3\. Optional function `request -> result` that derives result values
        from request values. Applied with `mkDefault` priority so explicit
        result settings take precedence. Use `fulfill'` if the result also
        needs the instance `name`.

        `fulfill'`

        : 4\. Optional function `{ request, name } -> result`. Lower-level
        variant of `fulfill` exposing the instance `name`. At most one of
        `fulfill` / `fulfill'` may be set.

        **Example:**

        ```nix
        { lib, config, options, ... }:
        let
          inherit (config.contractTypes.arithmetic) mkProviderType;
        in
        {
          imports = [
            # simple dummy contract with request/result both shaped `{ value: int }`
            <nixpkgs/nixos/tests/contracts/arithmetic-contract.nix>
          ];
          options.services.increment.arithmetic = lib.mkOption {
            default = config.contracts.arithmetic.requests;
            type = mkProviderType {
              fulfill = request: {
                value = request.value + 1;
              };
            };
          };
          config = {
            contracts.arithmetic.providers.increment.module = options.services.increment.arithmetic;
          };
        }
        ```
      '';
      type = functionTo optionType;
      readOnly = true;
      default =
        {
          providerOptions ? { },
          overrides ? { },
          fulfill ? null,
          fulfill' ? null,
        }:
        assert lib.assertMsg (
          fulfill == null || fulfill' == null
        ) "mkProviderType: at most one of `fulfill` and `fulfill'` may be set.";
        let
          fulfill'' = if fulfill != null then ({ request, ... }: fulfill request) else fulfill';
          inherit (contract.config) interface;
          mkExtended =
            k:
            lib.extendSubmodule (overrides.${k} or { }) (submodule {
              imports = interface.extraImports.${k};
              options = interface.${k};
            });
        in
        types.nestedAttrsOf (
          types.submodule (
            [
              {
                options = {
                  request = mkOption {
                    description = "Request of the contract instance.";
                    type = mkExtended "request";
                  };
                  result = mkOption {
                    description = "Result of the contract instance.";
                    default = { };
                    type = mkExtended "result";
                  };
                }
                // providerOptions;
              }
            ]
            ++ lib.optional (fulfill'' != null) (
              { config, name, ... }:
              {
                config.result = lib.mkDefault (fulfill'' {
                  inherit (config) request;
                  inherit name;
                });
              }
            )
          )
        );
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
