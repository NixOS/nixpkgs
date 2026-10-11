# Module of a contract type: the options of each entry in `contractTypes`.
{ lib, config, ... }:
let
  inherit (lib) mkOption types;

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

    consumerInterface = mkOption {
      description = ''
        The `interface` as a consumer sees it.
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
      defaultText = lib.literalMD "`interface`, with the `request` options also in `response`";
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
      default =
        overrides:
        types.submodule {
          imports = [ config.consumerInterface ];
          options = lib.mapAttrs (
            _: options:
            mkOption {
              type = types.submodule { options = lib.mapAttrs (_: mkOption) options; };
            }
          ) overrides;
          config = lib.mapAttrs (_: _: { }) overrides;
        };
      defaultText = lib.literalMD "a function that makes a submodule type from `interface` and `overrides`";
    };
  };
}
