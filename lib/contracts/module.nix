# Contracts module: routes requests from consumers to providers.
#
# This module does not depend on NixOS, so other module systems can import it.
{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  # A reference to a provider: an entry of `contracts.<type>.providers`.
  # Routing compares two references by their `loc`, and not by their values,
  # because the value of a provider option depends on the requests that it gets.
  providerRefType = types.mkOptionType {
    name = "providerRef";
    description = "provider reference";
    check = v: lib.isAttrs v && v ? module && v ? loc;
    merge = lib.mergeOneOption;
  };

  # Find the provider option from `module` and `contract`.
  # In a set of options, the first attribute of the path selects an attribute.
  # At an option, the remaining path is in the value of the option.
  resolveProvider =
    module: path:
    if lib.isOption module then
      {
        loc = module.loc ++ path;
        value = lib.getAttrFromPath path module.value;
      }
    else if path == [ ] then
      throw "contracts: a provider `module` must be an option, or a set of options with an attribute at `contract`."
    else
      resolveProvider module.${lib.head path} (lib.tail path);
in
{
  options = {
    contractTypes = mkOption {
      description = ''
        Contract types that consumers and providers can use.

        Each contract type has an `interface`: a module with the options
        `request` and `response`.
        Consumers and providers import this module into their submodule types.

        The contract types of nixpkgs are in `lib.contracts`.
        To add a contract type to nixpkgs, add a file in `lib/contracts/definitions/`.
        To add a contract type outside of nixpkgs, set it in this option.

        **Use contracts in a different module system:**

        1\. Import `lib.contract.module`.

        2\. Set this option to `lib.contracts`, so that the contract types of nixpkgs are available.

        The NixOS module `nixos/modules/contracts/default.nix` does these two steps.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule {
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
          };
        }
      );
    };

    contracts = mkOption {
      description = ''
        Contract instances, one attribute set for each contract type
        in [](#opt-contractTypes).

        A consumer sends its requests to `contracts.<type>.want`.
        A provider adds its option to `contracts.<type>.providers`.
        The user selects a provider with `contracts.<type>.defaultProvider`,
        and reads the responses from `contracts.<type>.results`.
      '';
      default = { };
      type = types.submodule {
        options = lib.mapAttrs (
          contractName: contractType:
          mkOption {
            description = ''
              Instances of the contract type `${contractName}`.

              ${contractType.meta.description}
            '';
            default = { };
            type = types.submodule (
              { config, ... }:
              {
                options = {
                  want = mkOption {
                    description = ''
                      Requests from consumers.
                      Each name must be unique for all consumers,
                      for example `<consumer>-<option>`.

                      Each entry has the options `request` and `response` of the interface of `${contractName}`.
                      A consumer sets only the `request`.
                      The `response` comes from the provider, through `results`.

                      **Example:**

                      ```nix
                      contracts.${contractName}.want."<consumer>-<option>" = {
                        inherit (config.services."<consumer>"."<option>") request;
                      };
                      ```
                    '';
                    default = { };
                    type = types.attrsOf (types.submodule { imports = [ contractType.interface ]; });
                  };

                  requests = mkOption {
                    description = "The `request` of each entry in `want`.";
                    readOnly = true;
                    type = types.attrsOf types.raw;
                    default = lib.mapAttrs (_: want: { inherit (want) request; }) config.want;
                    defaultText = lib.literalMD "the `request` of each entry in `want`";
                  };

                  providers = mkOption {
                    description = ''
                      Providers of this contract type.
                      Each provider has a *provider option*, in which the provider gets its requests
                      from `providerRequests.<provider>`.
                      The value of the provider option has an entry with a `response`
                      for each request that the provider gets, with the same name.

                      A provider module adds itself here with `module` and `contract`.
                      Thus the module takes `options` in its arguments:

                      ```nix
                      contracts.${contractName}.providers."<provider>".module = options.services."<provider>";
                      ```

                      `module` gives the other options of the provider,
                      for example to make a configuration form for the provider.
                    '';
                    default = { };
                    type = types.attrsOf (
                      types.submodule (provider: {
                        options = {
                          module = mkOption {
                            description = ''
                              The options of the provider: an option, or a set of options.
                              The provider option is at the path `contract` in `module`.
                            '';
                            type = types.raw;
                            example = lib.literalExpression "options.testing.hardcoded-secret";
                          };
                          contract = mkOption {
                            description = ''
                              The path of the provider option in `module`.
                              Set it to `[ ]` if `module` is the provider option.
                              If the path gets to an option before its end,
                              the remaining path is in the value of that option.
                            '';
                            type = types.listOf types.str;
                            default = [ contractName ];
                            defaultText = lib.literalExpression ''[ "<type>" ]'';
                          };
                          loc = mkOption {
                            description = "The `loc` of the provider option.";
                            readOnly = true;
                            internal = true;
                            type = types.listOf types.str;
                            default = (resolveProvider provider.config.module provider.config.contract).loc;
                            defaultText = lib.literalMD "the `loc` of the option at `contract` in `module`";
                          };
                          value = mkOption {
                            description = "The value of the provider option.";
                            readOnly = true;
                            internal = true;
                            type = types.raw;
                            default = (resolveProvider provider.config.module provider.config.contract).value;
                            defaultText = lib.literalMD "the `value` of the option at `contract` in `module`";
                          };
                        };
                      })
                    );
                    example = lib.literalExpression "{ hardcoded-secret.module = options.testing.hardcoded-secret; }";
                  };

                  defaultProvider = mkOption {
                    description = ''
                      The provider that gets the requests, one of `providers`.
                      To send an entry to a different provider, set `instances`.
                    '';
                    default = null;
                    type = types.nullOr providerRefType;
                    example = lib.literalExpression "config.contracts.fileSecrets.providers.hardcoded-secret";
                  };

                  instances = mkOption {
                    description = ''
                      For each entry in `want`, with the same name,
                      the provider that has the instance of the entry, one of `providers`.
                      The default is `defaultProvider`.
                      To connect an entry to a provider manually, set it to `null`.
                      A definition for one entry does not remove the default of the other entries.

                      **Example:**

                      ```nix
                      contracts.${contractName}.defaultProvider = config.contracts.${contractName}.providers."<provider>";
                      contracts.${contractName}.instances."<consumer>-<option>" =
                        config.contracts.${contractName}.providers."<other-provider>";
                      ```
                    '';
                    type = types.attrsOf (types.nullOr providerRefType);
                  };

                  providerRequests = mkOption {
                    description = ''
                      The requests that each provider must fulfill:
                      the entries of `requests` that `instances` sends to the provider.
                      A provider reads `providerRequests.<provider>`,
                      and not `requests`.
                      Each provider in `providers` has an entry,
                      which is empty when `instances` sends no request to the provider.

                      **Example:**

                      ```nix
                      services."<provider>".${contractName} = config.contracts.${contractName}.providerRequests."<provider>";
                      ```
                    '';
                    readOnly = true;
                    type = types.attrsOf (types.attrsOf types.raw);
                    default = lib.mapAttrs (
                      _: provider:
                      lib.filterAttrs (
                        name: _: config.instances.${name} != null && config.instances.${name}.loc == provider.loc
                      ) config.requests
                    ) config.providers;
                    defaultText = lib.literalMD "the entries of `requests` that `instances` sends to each provider";
                  };

                  results = mkOption {
                    description = ''
                      The `response` from the provider in `instances` for each entry in `want`, with the same name.

                      The user sets the `response` of a consumer option from this option:

                      ```nix
                      services."<consumer>"."<option>".response = config.contracts.${contractName}.results."<consumer>-<option>";
                      ```
                    '';
                    readOnly = true;
                    # Lazy, so that an entry without a provider does not make the other entries fail.
                    type = types.lazyAttrsOf types.raw;
                    default = lib.mapAttrs (
                      name: _:
                      if config.instances.${name} == null then
                        throw "contracts.${contractName}.want.${name}: no provider. Set `contracts.${contractName}.defaultProvider` or `contracts.${contractName}.instances.${name}`."
                      else
                        config.instances.${name}.value.${name}.response
                    ) config.want;
                    defaultText = lib.literalMD "the `response` from the provider in `instances` for each entry in `want`";
                  };
                };

                # A default for each entry, and not for the option,
                # so that a definition of one entry does not remove the defaults of the other entries.
                config.instances = lib.mapAttrs (_: _: lib.mkOptionDefault config.defaultProvider) config.want;
              }
            );
          }
        ) config.contractTypes;
      };
    };
  };
}
