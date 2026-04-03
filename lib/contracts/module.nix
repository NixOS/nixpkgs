{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (types)
    attrsOf
    enum
    nestedAttrsOf
    nullOr
    raw
    submodule
    ;
  # `or` fallbacks allow the docs build sandbox to evaluate this module:
  # the sandbox passes a fake `config` via `specialArgs` that lacks these attributes.
  upstream = config._upstreamContracts or { };
  contractTypes = config.contractTypes or lib.contracts;
in
{
  options = {
    contractTypes = mkOption {
      description = ''
        Types of contracts.
        For info on how to instantiate these, see `config.contracts`.

        To create a new contract type, add an instance of `config.contractTypes."<name>"`
        defining `meta` and `interface` options, or when adding to nixpkgs,
        preferably adding one in `lib/contracts`.

        Nixpkgs-shipped contract types (`lib.contracts`) are available automatically
        via a fallback in `contracts` option generation. Additional (user-defined)
        contract types added here are merged alongside the lib-shipped ones.

        **Integrating into a new module system** (e.g. home-manager, nix-darwin):

        1\. Import this module (`lib.contract.module`).

        2\. Seed `config.contractTypes` with `lib.contracts` so that nixpkgs-shipped
        contract definitions are available alongside any user-defined types.

        Both steps are combined in a thin wrapper module; see
        `nixos/modules/contracts/default.nix` for the reference implementation.
      '';
      # types are in `lib` as the docs build's sandbox has no `config`.
      type = attrsOf lib.contract.templateType;
    };
    contracts = mkOption {
      description = ''
        Contract instances, keyed by contract type.

        This option is system-agnostic - it works identically in NixOS
        and any module system that imports `lib.contract.module`.

        Consumers set `contracts.<type>.want`, providers set `contracts.<type>.providers`,
        and results are read from `contracts.<type>.results`.
      '';
      type = submodule {
        options = lib.mapAttrs (
          contractName: contractType:
          let
            inherit (contractType) meta interface;
            wantType = nestedAttrsOf (submodule {
              options = {
                request = mkOption {
                  description = ''
                    The request parameters.
                    Must match the `${contractName}` contract interface's request type.
                  '';
                  type = submodule {
                    imports = interface.extraImports.request;
                    options = interface.request;
                  };
                };
                result = mkOption {
                  description = ''
                    Result returned to the request by the provider's side of the `${contractName}` contract.
                    Must match the `${contractName}` contract interface's result type.
                  '';
                  type = submodule {
                    imports = interface.extraImports.result;
                    options = interface.result;
                  };
                };
              };
            });
          in
          mkOption {
            description = ''
              ${meta.description}

              Providers for the contract may be implemented by defining an option as follows:

              ```nix
              { lib, ... }:
              let
                inherit (lib.contracts.${contractName}) mkProviderType;
              in
              {
                options = {
                  ${contractName} = lib.mkOption {
                    description = ${"'"}'
                      Instances of contract `${contractName}`, including contract request/result and provider-specific options.

                      Option `config.contracts.${contractName}.instances` refers to providers' options like this one.
                    ${"'"}';
                    example = lib.literalExpression ${"'"}'
                      {
                        "<consumer>"."<instance>" = {
                          request = {
                            # options shared between any provider of the `${contractName}` contract
                            # "<attr>" = ...;
                          };
                          # provider-specific options:
                          # "<opt>" = ...;
                        };
                      }
                    ${"'"}';
                    type = mkProviderType {
                      # overrides.request = { "<attr>".default = ...; };
                      # overrides.result  = { "<attr>".default = ...; };
                      # providerOptions = {
                      #   "<opt>" = lib.mkOption {
                      #     type = lib.types."<type>";
                      #     description = "A provider-specific option.";
                      #   };
                      # };
                      fulfill = request: {
                        # "<attr>" = ...;
                      };
                      # fulfill' = { request, name }: { ... };  # variant exposing instance name
                    };
                  };
                };
              }
              ```
            '';
            type = submodule (contract: {
              options = {
                want = mkOption {
                  description = ''
                    Requests declared by consumers of the `${contractName}` contract, consisting of
                    request inputs and (once fulfilled) the provider's returned results.

                    `want` uses `nestedAttrsOf`, so consumers can organize entries at any depth:

                    ```nix
                    contracts.${contractName}.want."<consumer>" = {
                      secret = cfg.secret;                   # flat
                      db.primary = cfg.primaryDb;             # grouped
                      caches.region-a.fast = cfg.fastCache;   # deeply nested
                    };
                    ```

                    Results mirror the same structure:
                    `config.contracts.${contractName}.results."<consumer>".db.primary`, etc.

                    **NixOS module consumer:**

                    ```nix
                    { lib, config, ... }:
                    let
                      cfg = config.services."<consumer>";
                      inherit (lib.contracts) ${contractName};
                    in
                    {
                      options.services."<consumer>"."<option>" = lib.mkOption {
                        default = config.contracts.${contractName}.requests;
                        type = ${contractName}.mkContract {
                          request = {
                            # "<attr>".default = ...;
                          };
                        };
                      };

                      config = {
                        # NixOS modules namespace their own entries:
                        contracts.${contractName}.want."<consumer>" = {
                          inherit (cfg) <option>;
                        };

                        services."<consumer>"."<option>".result =
                          config.contracts.${contractName}.results."<consumer>"."<option>";
                      };
                    }
                    ```

                    **Modular service consumer:**

                    ```nix
                    { lib, config, ... }:
                    let
                      cfg = config."<consumer>";
                      inherit (lib.contracts) ${contractName};
                    in
                    {
                      _class = "service";
                      options."<consumer>"."<option>" = lib.mkOption {
                        default = config.contracts.${contractName}.requests;
                        type = ${contractName}.mkContract {
                          request = {
                            # "<attr>".default = ...;
                          };
                        };
                      };

                      config = {
                        # No manual prefix - the bridge auto-nests under the service tree path:
                        contracts.${contractName}.want = {
                          inherit (cfg) <option>;
                        };

                        # Results are scoped automatically:
                        cfg."<option>".result =
                          config.contracts.${contractName}.results."<option>";
                      };
                    }
                    ```

                    **Naming restrictions:**

                    `want` uses `nestedAttrsOf`, which distinguishes namespace keys from leaf
                    entries by checking whether an attrset's keys match the leaf submodule's
                    option names. Because each leaf has options `request` and `result`,
                    namespace keys (consumer names, option names) must not be literally
                    `request` or `result` - otherwise they would be misidentified as leaves.

                    NixOS modules and modular services share the same `want` namespace.
                    The bridge auto-nests modular service entries under the service tree
                    name, so a NixOS module that manually picks a consumer name matching
                    a `system.services` key would collide. To avoid this, NixOS modules
                    should use their option path as consumer name (e.g. `"stash"` from
                    `services.stash`), which by convention does not overlap with service
                    tree names.

                    **Providers** set `contracts.${contractName}.providers.<name>`:

                    ```nix
                    contracts.${contractName}.providers."<provider>" = config."<provider>".${contractName};
                    ```
                  '';
                  type = wantType;
                  default = { };
                };
                requests = mkOption {
                  description = ''
                    Request data for the `${contractName}` contract, with `result` attributes filtered out.

                    Providers read from this option to get consumer requests.

                    Only canonical request options (those declared in `interface.request`) are included.
                    Deprecated aliases added via `interface.extraImports.request` are intentionally excluded.
                  '';
                  type = nestedAttrsOf raw;
                  default =
                    if upstream ? ${contractName} then
                      upstream.${contractName}.requests
                    else
                      lib.mapNestedAttrs' wantType (v: {
                        request = lib.getAttrs (lib.attrNames interface.request) v.request;
                      }) contract.config.want;
                  defaultText = lib.literalExpression ''
                    lib.mapNestedAttrs' wantType
                      (v: { request = lib.getAttrs (lib.attrNames interface.request) v.request; })
                      contract.config.want
                  '';
                  readOnly = true;
                };
                providers = mkOption {
                  description = ''
                    Where to find instances of a provider of the `${contractName}` contract that can take request inputs to return results.

                    ```nix
                    contracts.${contractName}.providers."<provider>" = config."<provider>".${contractName};
                    ```

                    `nixos-contracts-bridge` automatically collects providers set by modular services
                    into the containing system's `contracts.${contractName}.providers`.

                    It may then be used where you configure the service consuming the `${contractName}` contract to manually set a provider:

                    ```nix
                    contracts.${contractName}.instances."<consumer>"."<instance>" = config.contracts.${contractName}.providers."<provider>";
                    ```

                    For an easier way to set providers, consider setting `defaultProviderName` or `defaultProvider`.
                  '';
                  type = attrsOf raw;
                };
                defaultProviderName = mkOption {
                  description = ''
                    Select the name of the default provider to use for the `${contractName}` contract.
                    Useful as a way to configure `defaultProvider` more amenable to UI generation.

                    Setting this for a contract means you no longer need to set providers for individual `instances`:

                    ```nix
                    contracts.${contractName}.defaultProviderName = "<provider>";
                    ```

                    For an alternate way to set a default provider, consider `defaultProvider`.

                    Note this options lacks `defaultProvider`'s graceful handling of contract renames.
                  '';
                  type = nullOr (enum (lib.attrNames contract.config.providers));
                  example = lib.literalExpression ''"hardcoded-secret"'';
                };
                defaultProvider = mkOption {
                  description = ''
                    The default provider for the `${contractName}` contract, alongside its configuration.

                    Setting this for a contract means you no longer need to set providers for individual `instances`:

                    ```nix
                    contracts.${contractName}.defaultProvider = config.contracts.${contractName}.providers."<provider>";
                    ```

                    For an alternate way to set a default provider, consider `defaultProviderName`.
                  '';
                  type = nullOr raw;
                  default =
                    let
                      inherit (contract.config) defaultProviderName;
                    in
                    if defaultProviderName == null then null else contract.config.providers.${defaultProviderName};
                  defaultText = lib.literalExpression ''
                    let
                      contract = config.contracts.${contractName};
                      inherit (contract) defaultProviderName;
                    in
                    if defaultProviderName == null then null else contract.providers.''${defaultProviderName}
                  '';
                  example = lib.literalExpression ''
                    config.contracts.fileSecrets.providers.hardcoded-secret
                  '';
                };
                instances = mkOption {
                  description = ''
                    Instances of the `${contractName}` contract.
                    By default returns `defaultProvider`, if set (potentially by `defaultProviderName`),
                    but may be overridden per instance like:

                    ```nix
                    contracts.${contractName}.instances."<consumer>"."<instance>" = config.contracts.${contractName}.providers."<provider>";
                    ```

                    Used in the consumer like:

                    ```nix
                    { lib, ... }:
                    let
                      inherit (lib.contracts) ${contractName};
                      inherit (config.contracts.${contractName}.results."<consumer>") <instance>;
                    in
                    {
                      options = {
                        "<instance>" = lib.mkOption {
                          description = ${"'"}'
                            An instance of contract `${contractName}`.
                            See `contracts.${contractName}.want.<name>.<name>.result`
                            for documentation on the type of its `.result` attribute.
                            Information specific to the provider may be set like:

                            ```nix
                            services."<provider>".${contractName}."<consumer>"."<instance>"."<attr>" = ...;
                            ```
                          ${"'"}';
                          default.result = <instance>;
                          defaultText = lib.literalExpression ${"'"}'
                            { result = config.contracts.${contractName}.results."<consumer>"."<instance>"; }
                          ${"'"}';
                          type = ${contractName}.mkContract {
                            request = {
                              # "<attr>".default = ...;
                            };
                          };
                        };
                      };
                    }
                    ```
                  '';
                  type = nestedAttrsOf raw;
                  # No option-level default: the docs build sandbox evaluates
                  # option defaults, and the assertion below must not fire there.
                  # The actual default is provided via `config.instances` in the
                  # submodule's config block (only evaluated at config time).
                };
                results = mkOption {
                  description = ''
                    Result data for the `${contractName}` contract, with `request` attributes filtered out.

                    This is a read-only calculated option that extracts the result values from
                    fulfilled contracts. It mirrors `requests` which filters to just request data
                    for providers.

                    **NixOS module consumer** - results are under the consumer name chosen in `want`:

                    ```nix
                    { lib, config, ... }:
                    let
                      inherit (lib.contracts) ${contractName};
                      inherit (config.contracts.${contractName}.results."<consumer>") <option>;
                    in
                    {
                      options.services."<consumer>"."<option>" = lib.mkOption {
                        description = ${"'"}'
                          An instance of contract `${contractName}`.
                          See `contracts.${contractName}.want.<name>.<name>.result`
                          for documentation on the type of its `.result` attribute.
                          Information specific to the provider may be set like:

                          ```nix
                          services."<provider>".${contractName}."<consumer>"."<option>"."<attr>" = ...;
                          ```
                        ${"'"}';
                        default.result = <option>;
                        defaultText = lib.literalExpression ${"'"}'
                          { result = config.contracts.${contractName}.results."<consumer>"."<option>"; }
                        ${"'"}';
                        type = ${contractName}.mkContract {
                          request = {
                            # "<attr>".default = ...;
                          };
                        };
                      };
                    }
                    ```

                    **Modular service consumer** - results are scoped automatically by
                    `_upstreamContracts`, so no prefix is needed:

                    ```nix
                    { lib, config, ... }:
                    {
                      _class = "service";
                      options."<consumer>"."<option>" = lib.mkOption {
                        type = lib.contracts.${contractName}.mkContract { ... };
                      };
                      config = {
                        contracts.${contractName}.want = { inherit (config."<consumer>") "<option>"; };
                        "<consumer>"."<option>".result =
                          config.contracts.${contractName}.results."<option>";
                      };
                    }
                    ```

                    The same scoped API applies to sub-services at any nesting depth.

                    **At the NixOS level** (e.g. in assertions), results include the full
                    service tree path added by the bridge:

                    ```nix
                    # root service "myService":
                    config.contracts.${contractName}.results.myService."<option>"

                    # sub-service "inner" under "outer":
                    config.contracts.${contractName}.results.outer.inner."<option>"
                    ```
                  '';
                  type = nestedAttrsOf raw;
                  default =
                    if upstream ? ${contractName} then
                      upstream.${contractName}.results
                    else if contract.config.defaultProvider == null && contract.config.want == { } then
                      # No consumers and no provider (e.g. docs sandbox) -- safe empty.
                      { }
                    else
                      lib.mapNestedAttrs' wantType (v: v.result) contract.config.instances;
                  defaultText = lib.literalExpression ''
                    lib.mapNestedAttrs' wantType
                      (v: v.result)
                      config.contracts.${contractName}.instances
                  '';
                  readOnly = true;
                };
              };
              # Provide the asserting default for `instances` via config rather
              # than on the option itself: the docs build sandbox evaluates option
              # defaults but does not evaluate submodule config blocks.
              config.instances = lib.mkOptionDefault (
                let
                  provider = contract.config.defaultProvider;
                in
                assert lib.assertMsg (provider != null) "contracts.${contractName}.defaultProvider is unset!";
                provider
              );
            });
          }
        ) contractTypes;
      };
    };
    _upstreamContracts = mkOption {
      type = attrsOf raw;
      internal = true;
      description = ''
        When populated, read-side contract options (`requests`, `defaultProvider`,
        `results`) delegate to this upstream source.

        Set automatically by `lib/services/lib.nix`'s `configure` function to
        connect a modular service's contract namespace to the containing system's
        resolved contracts. Each service level receives a scoped view where
        `results` is narrowed to just that service's entries - so services read
        results by option name directly, without a manual prefix.

        Propagates automatically from parent services to sub-services via
        `lib/services/service.nix`, with each level further scoping `results`
        under the sub-service's name.

        Write-side options (`want`, `providers`) remain local to the service.
        The bridge auto-nests each service's `want` under its service tree path
        and collects them into the containing system's contract namespace.
        See `nixos/modules/system/service/nixos-contracts-bridge.nix` for the
        reference bridge implementation.
      '';
    };
  };

  # When upstream contracts are available, inject the resolved `defaultProvider`
  # so consumers can read results without explicit wiring.
  config = {
    contracts = lib.mapAttrs (
      contractName: _:
      lib.optionalAttrs (upstream ? ${contractName}) {
        defaultProvider = lib.mkDefault upstream.${contractName}.defaultProvider;
      }
    ) contractTypes;
  };
}
