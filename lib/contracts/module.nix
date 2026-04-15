{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (types)
    attrsOf
    nestedAttrsOf
    raw
    submodule
    ;
  # `or` fallbacks allow the docs build sandbox to evaluate this module:
  # the sandbox passes a fake `config` via `specialArgs` that lacks these attributes.
  contractDefinitions = config.contractDefinitions or lib.contracts;
in
{
  options = {
    contractDefinitions = mkOption {
      description = ''
        Types of contracts.
        For info on how to instantiate these, see `config.contracts`.

        To create a new contract type, add an instance of `config.contractDefinitions."<name>"`
        defining `meta` and `interface` options, or when adding to nixpkgs,
        preferably adding one in `lib/contracts`.

        Nixpkgs-shipped contract types (`lib.contracts`) are available automatically
        via a fallback in `contracts` option generation. Additional (user-defined)
        contract types added here are merged alongside the lib-shipped ones.

        **Integrating into a new module system** (e.g. home-manager, nix-darwin):

        1\. Import this module (`lib/contracts/module.nix`).

        2\. Seed `config.contractDefinitions` with `lib.contracts` so that nixpkgs-shipped
        contract definitions are available alongside any user-defined types.

        Both steps are combined in a thin wrapper module; see
        `nixos/modules/contracts/default.nix` for the reference implementation.
      '';
      # types are in `lib` as the docs build's sandbox has no `config`.
      type = attrsOf raw;
    };
    contracts = mkOption {
      description = ''
        Contract instances, keyed by contract type.

        This option is system-agnostic - it works identically in NixOS
        and any module system that imports `lib/contracts/module.nix`.

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
                    options = interface.request;
                  };
                };
                result = mkOption {
                  description = ''
                    Result returned to the request by the provider's side of the `${contractName}` contract.
                    Must match the `${contractName}` contract interface's result type.
                  '';
                  type = submodule {
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

                    **Naming restrictions:**

                    `want` uses `nestedAttrsOf`, which distinguishes namespace keys from leaf
                    entries by checking whether an attrset's keys match the leaf submodule's
                    option names. Because each leaf has options `request` and `result`,
                    namespace keys (consumer names, option names) must not be literally
                    `request` or `result` - otherwise they would be misidentified as leaves.

                    See `providers` for how providers register themselves.
                  '';
                  type = wantType;
                  default = { };
                };
                requests = mkOption {
                  description = ''
                    Request data for the `${contractName}` contract, with `result` attributes filtered out.

                    Providers read from this option to get consumer requests.

                    Only canonical request options (those declared in `interface.request`) are included.
                  '';
                  type = nestedAttrsOf raw;
                  default =
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

                    Each entry is `{ module, contract? }` where `module` is
                    the provider's option set (so `.loc` is reachable for GUI
                    generation) and `contract` is the relative path within
                    `module.value` to the contract instances. `contract` is
                    inferred when omitted: `[ "${contractName}" ]` if
                    `module.value` has that attribute (the conventional
                    sub-option naming), otherwise `[ ]` (i.e. `module` is
                    itself the contract-typed option).

                    ```nix
                    contracts.${contractName}.providers."<provider>".module = options."<provider>";
                    ```

                    Per-instance overrides are written by setting an
                    `instances.<consumer>.<...>` leaf to a provider entry
                    directly; the `instances` option's `apply` resolves the
                    reference at the matching path.

                    For an easier way to pick a single provider for every
                    instance, consider `defaultProviderName` / `defaultProvider`.
                  '';
                  type = attrsOf raw;
                };
                instances = mkOption {
                  description = ''
                    Instances of the `${contractName}` contract.
                    By default extracts the contract instances from
                    `defaultProvider.module.value` (using `defaultProvider.contract`,
                    defaulting to `[ "${contractName}" ]`), if set (potentially
                    by `defaultProviderName`), but may be overridden per instance.

                    Each leaf is a provider reference `{ module, contract? }`
                    (same shape as `providers.<name>`); the option's `apply`
                    resolves it path-aware to the provider's instance at the
                    matching path. GUIs read the override as a typed
                    reference rather than an opaque value.

                    Per-instance overrides compose against the
                    `defaultProvider`-derived tree without
                    `lib.recursiveUpdate`: `nestedAttrsOf` runs priority
                    filtering at each leaf, so a `mkDefault` /
                    `mkOptionDefault`-priority default at one path is
                    preserved when another module sets a normal-priority
                    override at a sibling path.

                    ```nix
                    contracts.${contractName}.defaultProviderName = "<default>";
                    contracts.${contractName}.instances."<consumer>"."<instance>" =
                      config.contracts.${contractName}.providers."<other>";
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
                  # Resolve provider-reference leaves (`{ module, contract? }`)
                  # to the provider's instance at the matching path. Path-aware
                  # so a ref at `<consumer>.<instance>` resolves to that
                  # provider's specific consumer/instance, not its full tree.
                  # Already-resolved instance attrsets at leaves pass through
                  # unchanged - the apply can't tell them apart from values
                  # produced by resolving a ref higher up - but writing them
                  # by hand defeats GUI introspection and is discouraged.
                  apply =
                    let
                      resolveRef =
                        v:
                        if v.contract or null != null then
                          lib.getAttrFromPath v.contract v.module.value
                        else if v.module.value ? ${contractName} then
                          v.module.value.${contractName}
                        else
                          v.module.value;
                      walk =
                        path: v:
                        if !lib.isAttrs v then
                          v
                        else if v ? module then
                          lib.getAttrFromPath path (resolveRef v)
                        else
                          lib.mapAttrs (n: walk (path ++ [ n ])) v;
                    in
                    walk [ ];
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
                  '';
                  type = nestedAttrsOf raw;
                  default = lib.mapNestedAttrs' wantType (v: v.result) contract.config.instances;
                  defaultText = lib.literalExpression ''
                    lib.mapNestedAttrs' wantType
                      (v: v.result)
                      config.contracts.${contractName}.instances
                  '';
                  readOnly = true;
                };
              };
            });
          }
        ) contractDefinitions;
      };
    };
  };
}
