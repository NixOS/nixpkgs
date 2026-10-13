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

  inherit (config) contractTypes;

  # The option `contracts.warnings`.
  # Thus a contract type cannot have the name `warnings`.
  warningsModule =
    { config, ... }:
    {
      options.warnings = mkOption {
        description = ''
          Warnings from the aliases in `contracts`, for example from `lib.mkRenamedOptionModule`,
          and the warnings of each contract type.
          In NixOS, these warnings go to the option `warnings`.
        '';
        type = types.listOf types.str;
        default = [ ];
      };
      config.warnings = lib.concatMap (name: config.${name}.warnings) (lib.attrNames contractTypes);
    };
in
{
  options = {
    contractTypes = mkOption {
      description = ''
        Contract types that consumers and providers can use.

        Each contract type has an `interface`: a module with the options
        `request` and `response`.
        Consumers and providers import this module into their submodule types.
        To make the submodule type of a consumer, use `mkContract`.

        The contract types of nixpkgs are in `lib.contracts`.
        To add a contract type to nixpkgs, add a file in `lib/contracts/definitions/`.
        To add a contract type outside of nixpkgs, set it in this option.

        **Use contracts in a different module system:**

        1\. Import `lib.contract.module`.

        2\. Add the contract types of `lib.contracts` to this option.
        Set only the options that a file in `lib/contracts/definitions/` sets, such as `meta` and `interface`,
        because the other options are read-only.

        The NixOS module `nixos/modules/contracts/default.nix` does these two steps.
      '';
      default = { };
      type = types.attrsOf lib.contract.definitionType;
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
        imports = [ warningsModule ];
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
              let
                entryType = types.submodule { imports = [ contractType.consumerInterface ]; };
                # The `request` of an entry, without `warnings`.
                request = want: lib.getAttrs contractType.requestOptionNames want.request;
                # An entry has only the keys of the interface, such as `request`.
                # Other attribute sets are namespaces, for example `want.<consumer>`.
                isEntry = v: v != { } && lib.isNestedAttrsLeaf lib.all entryType v;
                # Apply `f path entry` to each entry in `want` for which `pred path` is true.
                # Remove empty namespaces, for example from `mkIf false`,
                # because a provider reads `{ }` as an entry.
                filterMapEntries =
                  pred: f:
                  let
                    go =
                      path:
                      lib.concatMapAttrs (
                        name: v:
                        let
                          path' = path ++ [ name ];
                          mapped = go path' v;
                        in
                        if isEntry v then
                          lib.optionalAttrs (pred path') { ${name} = f path' v; }
                        else
                          lib.optionalAttrs (mapped != { }) { ${name} = mapped; }
                      );
                  in
                  go [ ] config.want;
                mapEntries = filterMapEntries (_: true);
                # The provider in `instances` for the entry at `path`.
                instanceOf = path: lib.getAttrFromPath path config.instances;
              in
              {
                options = {
                  want = mkOption {
                    description = ''
                      Requests from consumers.
                      Entries can be in nested attribute sets of any depth.
                      Each consumer puts its entries in an attribute set with its own name,
                      for example `want.<consumer>.<option>`.
                      An attribute set that contains only names of interface options,
                      such as `request`, is an entry and not a namespace.
                      Thus a name in a namespace must not be the name of an interface option,
                      such as `request` or `response`.

                      Each entry has the options `request` and `response` of the interface of `${contractName}`.
                      A consumer sets only the `request`.
                      The `response` comes from the provider, through `results`.

                      **Example:**

                      ```nix
                      contracts.${contractName}.want."<consumer>" = {
                        "<option>" = { inherit (config.services."<consumer>"."<option>") request; };
                        "<group>"."<option>" = { inherit (config.services."<consumer>"."<group>"."<option>") request; };
                      };
                      ```
                    '';
                    default = { };
                    type = types.nestedAttrsOf entryType;
                  };

                  requests = mkOption {
                    description = ''
                      The `request` of each entry in `want`, at the same path.
                      It has only the `request` options of the interface.
                    '';
                    readOnly = true;
                    type = types.attrsOf types.raw;
                    default = mapEntries (_: want: { request = request want; });
                    defaultText = lib.literalMD "the `request` of each entry in `want`";
                  };

                  providers = mkOption {
                    description = ''
                      Providers of this contract type.
                      Each provider has a *provider option*, in which the provider gets its requests
                      from `providerRequests.<provider>`.
                      The value of the provider option has an entry with a `response`
                      for each request that the provider gets, at the same path.

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
                      To select the provider by its name, set `defaultProviderName`.
                    '';
                    default =
                      if config.defaultProviderName == null then null else config.providers.${config.defaultProviderName};
                    defaultText = lib.literalMD "the provider in `providers` with the name `defaultProviderName`, or `null`";
                    type = types.nullOr providerRefType;
                    example = lib.literalExpression "config.contracts.fileSecrets.providers.hardcoded-secret";
                  };

                  defaultProviderName = mkOption {
                    description = ''
                      The name of the provider in `providers` that gets the requests.
                      This sets the default of `defaultProvider`.
                    '';
                    default = null;
                    type = types.nullOr (types.enum (lib.attrNames config.providers));
                    example = "hardcoded-secret";
                  };

                  instances = mkOption {
                    description = ''
                      For each entry in `want`, at the same path,
                      the provider that has the instance of the entry, one of `providers`.
                      The default is `defaultProvider`.
                      To connect an entry to a provider manually, set it to `null`.
                      A definition for one entry does not remove the default of the other entries.

                      **Example:**

                      ```nix
                      contracts.${contractName}.defaultProvider = config.contracts.${contractName}.providers."<provider>";
                      contracts.${contractName}.instances."<consumer>"."<option>" =
                        config.contracts.${contractName}.providers."<other-provider>";
                      ```
                    '';
                    type = types.nestedAttrsOf (types.nullOr providerRefType);
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
                      filterMapEntries (path: instanceOf path != null && (instanceOf path).loc == provider.loc) (
                        _: want: { request = request want; }
                      )
                    ) config.providers;
                    defaultText = lib.literalMD "the entries of `requests` that `instances` sends to each provider";
                  };

                  warnings = mkOption {
                    description = ''
                      Warnings from the aliases in `requestAliases`,
                      for each entry in `want` that sets an alias.
                      In NixOS, these warnings go to the option `warnings`.
                    '';
                    readOnly = true;
                    type = types.listOf types.str;
                    default = lib.concatLists (
                      lib.collect lib.isList (
                        mapEntries (
                          path: want:
                          map (
                            warning: "contracts.${contractName}.want.${lib.showAttrPath path}.request: ${warning}"
                          ) want.request.warnings
                        )
                      )
                    );
                    defaultText = lib.literalMD "the warnings of the `request` of each entry in `want`";
                  };

                  results = mkOption {
                    description = ''
                      For each entry in `want`, at the same path,
                      the `request` of the entry and the `response` from the provider in `instances` in one attribute set.
                      Thus a consumer reads a request value from the same place as the response.
                      The `request` does not have the aliases from `requestAliases`.
                      A `response` attribute takes precedence over a `request` attribute with the same name.

                      The user sets the `response` of a consumer option from this option:

                      ```nix
                      services."<consumer>"."<option>".response = config.contracts.${contractName}.results."<consumer>"."<option>";
                      ```
                    '';
                    readOnly = true;
                    # Lazy, so that an entry without a provider does not make the other entries fail.
                    type = types.lazyAttrsOf types.raw;
                    default = mapEntries (
                      path: want:
                      if instanceOf path == null then
                        throw "contracts.${contractName}.want.${lib.showAttrPath path}: no provider. Set `contracts.${contractName}.defaultProvider` or `contracts.${contractName}.instances.${lib.showAttrPath path}`."
                      else
                        request want // (lib.getAttrFromPath path (instanceOf path).value).response
                    );
                    defaultText = lib.literalMD "the `request` of each entry in `want`, with the `response` from the provider in `instances`";
                  };
                };

                # A default for each entry, and not for the option,
                # so that a definition of one entry does not remove the defaults of the other entries.
                config.instances = mapEntries (_: _: lib.mkOptionDefault config.defaultProvider);
              }
            );
          }
        ) config.contractTypes;
      };
    };
  };
}
