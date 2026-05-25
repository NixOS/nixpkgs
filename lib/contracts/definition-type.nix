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
    _mkProviderType = mkOption {
      description = ''
        Create a `nestedAttrsOf` type for provider instances.

        Note that this should not be used directly, as `defaults` specified get lost once any value gets set manually.
        Instead, use `config.contracts.<contract>.mkProviderType`.

        `<contract>._mkProviderType :: { providerOptions?, overrides?, fulfill?, fulfill'? } -> optionType`

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

        : 4\. Optional function `{ request, name, instance } -> result`. Lower-level
        variant of `fulfill` exposing the instance `name` and the full submodule
        `instance` (including provider-specific options). At most one of
        `fulfill` / `fulfill'` may be set.

        `_requests`

        : 5\. Internal. Pre-bound by `contracts.<contract>.mkProviderType`, which is the
        recommended call site for providers. Forwards consumer `want` request data
        into each leaf at `mkDefault` priority (1000) so provider-specific options
        do not silently mask consumer wants via `nestedAttrsOf` leaf-priority filtering.

        **Example:**

        ```nix
        { lib, config, options, ... }:
        let
          inherit (config.contracts) arithmetic;
        in
        {
          imports = [
            # simple dummy contract with request/result both shaped `{ value: int }`
            <nixpkgs/nixos/tests/contracts/arithmetic-contract.nix>
          ];
          options.services.increment.arithmetic = lib.mkOption {
            default = arithmetic.providerRequests.increment;
            type = arithmetic.mkProviderType {
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
          _requests ? null,
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
              # Forward consumer `want` request data at `mkDefault` (priority 1000)
              # so it beats `overrides.request.<field>.default` (`mkOptionDefault`,
              # priority 1500) but loses to explicit deployer writes (normal, 100).
              # Without this, writing any provider-specific option causes
              # `nestedAttrsOf`'s leaf-level priority filtering to drop the outer
              # `mkOptionDefault` default that carried the consumer's want,
              # leaving `overrides.request.<field>.default` as the only surviving
              # value -- silently masking the consumer's declared overrides.
              #
              # The path-split search strips the provider option path prefix from
              # `options.request.loc` to recover the leaf's position within
              # `_requests` (the want-derived request tree pre-bound by the caller).
              (
                { options, ... }:
                if _requests == null then
                  { }
                else
                  {
                    config.request =
                      let
                        leafPath = lib.init options.request.loc;
                        matchN = lib.findFirst (
                          n:
                          let
                            v = lib.attrByPath (lib.drop n leafPath) null _requests;
                          in
                          v != null && v ? request
                        ) null (lib.range 0 (lib.length leafPath));
                        wantRequest =
                          if matchN != null then (lib.attrByPath (lib.drop matchN leafPath) null _requests).request else null;
                      in
                      lib.mkIf (wantRequest != null) (lib.mkDefault wantRequest);
                  }
              )
            ]
            ++ lib.optional (fulfill'' != null) (
              { config, name, ... }:
              {
                config.result = lib.mkDefault (fulfill'' {
                  inherit (config) request;
                  inherit name;
                  instance = config;
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
