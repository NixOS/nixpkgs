# Module of a contract type: the options of each entry in `contractTypes`.
{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  # Module that imports `interface`, and adds the attributes in `overrides` to its options.
  # The empty definitions let the user omit an option of the interface,
  # if each of its options has a default.
  interfaceWith = interface: overrides: {
    imports = [ interface ];
    options = lib.mapAttrs (
      _: options:
      mkOption {
        type = types.submodule { options = lib.mapAttrs (_: mkOption) options; };
      }
    ) overrides;
    config = lib.mapAttrs (_: _: { }) overrides;
  };
  # The options in `request` or `response` of `interface`.
  interfaceOptions = (lib.evalModules { modules = [ config.interface ]; }).options;
  subOptions = name: removeAttrs (interfaceOptions.${name}.type.getSubOptions [ ]) [ "_module" ];
in
{
  options = {
    meta = mkOption {
      description = "Information about the contract type and its maintenance.";
      type = types.submodule {
        options = {
          description = mkOption {
            description = "What the contract type is for.";
            type = types.str;
          };
          maintainers = mkOption {
            description = "Maintainers of the contract type.";
            type = types.listOf types.attrs;
          };
        };
      };
    };

    interface = mkOption {
      description = "Module with the options `request` and `response`.";
      type = types.deferredModule;
    };

    requestAliases = mkOption {
      description = ''
        Modules that add aliases to the options of `request`,
        for example `lib.mkRenamedOptionModule [ "oldName" ] [ "newName" ]`.
        Consumers can set an alias.
        Providers do not get the aliases:
        the `request` of a consumer, and the `request` in `contracts.<type>.results`,
        have only the `request` options of `interface`.
        The warnings of the aliases go to `contracts.<type>.warnings`.
        See [](#contracts-rename-request) for an example.
      '';
      type = types.listOf types.deferredModule;
      default = [ ];
    };

    requestOptionNames = mkOption {
      description = "Names of the `request` options of `interface`, without the aliases.";
      type = types.listOf types.str;
      internal = true;
      readOnly = true;
      default = lib.attrNames (subOptions "request");
      defaultText = lib.literalMD "the names of the `request` options of `interface`";
    };

    consumerInterface = mkOption {
      description = ''
        The `interface` as a consumer sees it.
        A consumer can also set the options of `requestAliases` in `request`.
        The value of `request` has only the `request` options of `interface` and `warnings`.
        Thus a consumer can forward its `request` to `want`, and the aliases do not apply two times.
        `response` also has the options of `request`, as in `contracts.<type>.results`.
        A `response` option takes precedence over a `request` option with the same name.
        These options do not have the `default` and `apply` of the `request` options,
        because their value comes from the request in `want`.
        `mkContract` and the entries in `want` use this module.
      '';
      type = types.deferredModule;
      internal = true;
      readOnly = true;
      default = {
        imports = [ config.interface ];
        options.request = mkOption {
          type = types.submodule {
            imports = config.requestAliases;
            # `lib.mkRenamedOptionModule` adds its warning to this option.
            options.warnings = mkOption {
              description = "Warnings from the aliases in `requestAliases`.";
              type = types.listOf types.str;
              default = [ ];
              internal = true;
            };
          };
          apply = lib.getAttrs (config.requestOptionNames ++ [ "warnings" ]);
        };
        options.response = mkOption {
          type = types.submodule {
            options = lib.mapAttrs (
              _: option:
              mkOption {
                inherit (option) type;
                description = option.description or null;
              }
            ) (removeAttrs (subOptions "request") (lib.attrNames (subOptions "response")));
          };
        };
      };
      defaultText = lib.literalMD "`interface`, with `requestAliases` and `warnings` in `request`, and the `request` options also in `response`";
    };

    mkContract = mkOption {
      description = ''
        Make a submodule type that imports `consumerInterface`,
        and add the attributes in `overrides` to its options.

        `mkContract :: attrs -> optionType`

        **Inputs:**

        `overrides`

        : 1\. For each option of the interface, such as `request`,
          an attribute set with the attributes to add to each of its options,
          such as `default` or `readOnly`.

        **Example:**

        ```nix
        lib.contracts.fileSecrets.mkContract {
          request.owner = {
            default = cfg.user;
            readOnly = true;
          };
        }
        ```

        The result is the same type as:

        ```nix
        types.submodule {
          imports = [ lib.contracts.fileSecrets.consumerInterface ];
          options.request = mkOption {
            type = types.submodule {
              options.owner = mkOption {
                default = cfg.user;
                readOnly = true;
              };
            };
          };
          config.request = { };
        }
        ```

        The empty definition `config.request = { }` lets the user omit `request`,
        if each option of `request` has a default.
      '';
      type = types.functionTo types.optionType;
      readOnly = true;
      default = overrides: types.submodule (interfaceWith config.consumerInterface overrides);
      defaultText = lib.literalMD "a function that makes a submodule type from `interface` and `overrides`";
    };

    mkProviderType = mkOption {
      description = ''
        Make the type of the option in which a provider gets its requests.
        The type is `nestedAttrsOf` a submodule that imports `interface`.

        `mkProviderType :: { overrides?, providerOptions?, fulfill?, fulfill'? } -> optionType`

        **Inputs:**

        `overrides`

        : 1\. Attributes to add to the options of the interface, as in `mkContract`.

        `providerOptions`

        : 2\. Options of the provider that are not part of the contract type.
          They are in the option `providerOptions` of each entry.

        `fulfill`

        : 3\. Function from the `request` of an entry to its `response`.
          Each attribute of the result has `mkDefault` priority,
          thus a definition of the same `response` option replaces it.

        `fulfill'`

        : 4\. Function from `{ request, name, loc, instance }` to the `response` of an entry.
          `name` is the last attribute name of the entry,
          `loc` is the location of the entry,
          and `instance` is the configuration of the entry.
          Set `fulfill` or `fulfill'`, not the two.

        **Example:**

        ```nix
        { config, options, ... }:
        {
          options.services.increment.number = lib.mkOption {
            type = config.contractTypes.number.mkProviderType {
              fulfill = request: { value = request.value + 1; };
            };
          };
          config = {
            services.increment.number = config.contracts.number.providerRequests.increment;
            contracts.number.providers.increment.module = options.services.increment;
          };
        }
        ```
      '';
      type = types.functionTo types.optionType;
      readOnly = true;
      default =
        {
          overrides ? { },
          providerOptions ? { },
          fulfill ? null,
          fulfill' ? null,
        }:
        assert lib.assertMsg (
          fulfill == null || fulfill' == null
        ) "mkProviderType: set `fulfill` or `fulfill'`, not the two.";
        let
          fulfill'' = if fulfill != null then { request, ... }: fulfill request else fulfill';
          inherit (config) interface;
        in
        types.nestedAttrsOf (
          types.submodule (
            {
              config,
              options,
              name,
              ...
            }:
            {
              imports = [ (interfaceWith interface overrides) ];
              options.providerOptions = mkOption {
                description = "Options of the provider that are not part of the contract type.";
                default = { };
                type = types.submodule { options = providerOptions; };
              };
              config.response = lib.mkIf (fulfill'' != null) (
                lib.mapAttrs (_: lib.mkDefault) (fulfill'' {
                  inherit (config) request;
                  inherit name;
                  loc = lib.init options.request.loc;
                  instance = config;
                })
              );
            }
          )
        );
      defaultText = lib.literalMD "a function that makes a `nestedAttrsOf` type from `interface` and the inputs";
    };
  };
}
