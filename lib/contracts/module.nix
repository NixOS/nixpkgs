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
  # `or` fallback allows the docs build sandbox to evaluate this module:
  # the sandbox passes a fake `config` via `specialArgs` that lacks this attribute.
  contractDefinitions = config.contractDefinitions or lib.contracts;

  # A provider *reference* (`{ module, contract? }`) like `raw`, but mergeable:
  # multiple definitions are allowed as long as they all agree on
  # `module.loc` (the only field routing reads -- `routedName` matches a
  # reference to a provider by its `module.loc`). `raw`'s `mergeOneOption`
  # throws on any second definition; `mergeEqualOption` cannot help because two
  # references to the same provider differ in `module.value` (a thunk/function,
  # never `==`). Comparing only `module.loc` lets the legitimate duplicates a
  # node can accumulate -- e.g. a host that co-locates several apps, each of
  # whose routing modules sets the same node-wide `defaultProvider` -- collapse
  # to one, while still rejecting a genuine conflict (two different providers).
  providerRefType = lib.mkOptionType {
    name = "providerRef";
    description = "contract provider reference";
    # Same permissive check as `raw`: a reference is an opaque `{ module; ... }`.
    check = lib.types.raw.check;
    merge =
      loc: defs:
      let
        locOf = def: def.value.module.loc or null;
        first = lib.head defs;
        firstLoc = locOf first;
        allAgree = lib.all (def: locOf def == firstLoc) defs;
      in
      if allAgree then
        first.value
      else
        throw "The option `${lib.showOption loc}' has conflicting provider references (different `module.loc`) from: ${
          lib.concatMapStringsSep ", " (def: def.file) defs
        }.";
  };
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

        1\. Import this module (`lib.contract.module`).

        2\. Seed `config.contractDefinitions` with `lib.contracts` so that nixpkgs-shipped
        contract definitions are available alongside any user-defined types.

        Both steps are combined in a thin wrapper module; see
        `nixos/modules/contracts/default.nix` for the reference implementation.
      '';
      # types are in `lib` as the docs build's sandbox has no `config`.
      type = attrsOf lib.contract.definitionType;
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
              { lib, config, ... }:
              let
                inherit (lib.contract.forModule config) ${contractName};
                # or, outside of modules NixOS wants to build sandboxed for the manual:
                # inherit (config.contracts) ${contractName};
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
                    type = ${contractName}.mkProviderType {
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
            type = submodule (
              contract:
              let
                # Resolve a provider reference (`{ module, contract? }`) to the
                # provider's contract instances - the `instances` apply, lifted
                # out so `resolvedInstances` and `providerRequests` share it.
                resolveRef =
                  v:
                  if v.contract or null != null then
                    lib.getAttrFromPath v.contract v.module.value
                  else if v.module.value ? ${contractName} then
                    v.module.value.${contractName}
                  else
                    v.module.value;
                # The `providers` key whose registration references the same
                # option as `ref` (matched on `module.loc`, a list of strings
                # cheap to force - unlike the provider's value, which may not
                # even evaluate outside its own NixOS context). `null` when no
                # provider matches (e.g. a hand-written resolved instance).
                routedName =
                  ref:
                  lib.findFirst (
                    name: contract.config.providers.${name}.module.loc or null == ref.module.loc or null
                  ) null (lib.attrNames contract.config.providers);
                # Walk the `instances` ref tree, applying `f path ref` at each
                # leaf (`v ? module`). Path-aware so a ref nested above several
                # leaves resolves per leaf. Non-ref attrsets recurse; non-attrs
                # (already-resolved leaves) pass through.
                resolveInstanceTree =
                  f:
                  let
                    walk =
                      path: v:
                      if !lib.isAttrs v then
                        v
                      else if v ? module then
                        f path v
                      else
                        lib.mapAttrs (n: walk (path ++ [ n ])) v;
                  in
                  walk [ ] contract.config.instances;
                # Path-aware filter over a `nestedAttrsOf` tree, preserving
                # structure: keep each leaf (per `wantType`'s leaf detection)
                # only when `keep path leaf`, and prune now-empty namespaces.
                filterNestedAttrs =
                  keep:
                  let
                    recurse =
                      path: v:
                      if lib.isNestedAttrsLeaf lib.any wantType.nestedTypes.elemType v then
                        lib.optionalAttrs (keep path v) v
                      else
                        lib.filterAttrs (_: sub: sub != { }) (lib.mapAttrs (n: recurse (path ++ [ n ])) v);
                  in
                  recurse [ ];
              in
              {
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
                      Deprecated aliases added via `interface.extraImports.request` are intentionally excluded.
                    '';
                    type = nestedAttrsOf raw;
                    default = lib.mapNestedAttrs' wantType (v: {
                      request = lib.getAttrs (lib.attrNames interface.request) v.request;
                    }) contract.config.want;
                    defaultText = lib.literalExpression ''
                      lib.mapNestedAttrs' wantType
                        (v: { request = lib.getAttrs (lib.attrNames interface.request) v.request; })
                        contract.config.want
                    '';
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
                      instance, consider `defaultProvider` / `defaultProviderName`.
                    '';
                    type = attrsOf raw;
                  };
                  defaultProvider = mkOption {
                    description = ''
                      The default provider for the `${contractName}` contract, alongside its configuration.
                      Like `providers.<name>`, this is conventionally
                      `{ module, contract? }` (with `module.value`/`module.loc`),
                      not the resolved config value directly.

                      Setting this for a contract means you no longer need to set providers for individual `instances`:

                      ```nix
                      contracts.${contractName}.defaultProvider = config.contracts.${contractName}.providers."<provider>";
                      ```

                      May also be set indirectly via `defaultProviderName`.
                    '';
                    type = nullOr providerRefType;
                    default =
                      if contract.config.defaultProviderName == null then
                        null
                      else
                        contract.config.providers.${contract.config.defaultProviderName};
                    defaultText = lib.literalExpression ''
                      if contracts.${contractName}.defaultProviderName == null then null
                      else contracts.${contractName}.providers.''${contracts.${contractName}.defaultProviderName}
                    '';
                    example = lib.literalExpression ''
                      config.contracts.fileSecrets.providers.hardcoded-secret
                    '';
                  };
                  defaultProviderName = mkOption {
                    description = ''
                      The name of the default provider for the `${contractName}` contract.
                      Convenience alias for `defaultProvider`: picks `providers."<name>"` by
                      name rather than reference.

                      ```nix
                      contracts.${contractName}.defaultProviderName = "<provider>";
                      ```
                    '';
                    type = nullOr (enum (lib.attrNames contract.config.providers));
                    default = null;
                  };
                  instances = mkOption {
                    description = ''
                      Instances of the `${contractName}` contract.
                      By default extracts the contract instances from
                      `defaultProvider.module.value` (using `defaultProvider.contract`,
                      defaulting to `[ "${contractName}" ]`), if set, but may be
                      overridden per instance.

                      Each leaf is a provider reference `{ module, contract? }`
                      (same shape as `providers.<name>`); `resolvedInstances`
                      resolves it path-aware to the provider's instance at the
                      matching path, and `providerRequests` resolves it to the
                      routed provider's name. GUIs read the override as a typed
                      reference rather than an opaque value.

                      Per-instance overrides compose against the
                      `defaultProvider`-derived tree without
                      `lib.recursiveUpdate`: `nestedAttrsOf` runs priority
                      filtering at each leaf, so a `mkDefault` /
                      `mkOptionDefault`-priority default at one path is
                      preserved when another module sets a normal-priority
                      override at a sibling path.

                      ```nix
                      contracts.${contractName}.defaultProvider = config.contracts.${contractName}.providers."<default>";
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
                    # Holds the per-leaf provider references (no `apply`): both
                    # `resolvedInstances` (ref -> instance value) and
                    # `providerRequests` (ref -> routed provider name) derive from
                    # this raw ref tree, so the routing decision has a single
                    # source of truth that retains the reference (hence its
                    # `module.loc`, needed to recover the provider name).
                    type = nestedAttrsOf raw;
                    # No option-level default: the docs build sandbox evaluates
                    # option defaults, and the assertion below must not fire there.
                    # The actual default is provided via `config.instances` in the
                    # submodule's config block (only evaluated at config time).
                  };
                  resolvedInstances = mkOption {
                    description = ''
                      Resolved instances of the `${contractName}` contract: the
                      `instances` provider-reference tree with each leaf resolved
                      path-aware to the provider's instance at its path.

                      A computed, read-only view of `instances`. Already-resolved
                      instance attrsets at leaves pass through unchanged - the
                      resolution can't tell them apart from values produced by
                      resolving a ref higher up - but writing them by hand defeats
                      GUI introspection and is discouraged.
                    '';
                    type = nestedAttrsOf raw;
                    # Resolve provider-reference leaves (`{ module, contract? }`)
                    # to the provider's instance at the matching path. Path-aware
                    # so a ref at `<consumer>.<instance>` resolves to that
                    # provider's specific consumer/instance, not its full tree.
                    # Computed but overridable (like `requests` / `results`) so a
                    # cross-eval bridge can force-inject the containing system's
                    # resolution (see `lib/services/lib.nix`).
                    default = resolveInstanceTree (path: ref: lib.getAttrFromPath path (resolveRef ref));
                    defaultText = lib.literalExpression ''
                      <config.contracts.${contractName}.instances with each provider reference resolved to its instance>
                    '';
                  };
                  providerRequests = mkOption {
                    description = ''
                      Request data for the `${contractName}` contract, grouped by
                      the provider each request is routed to.

                      `providerRequests."<provider>"` mirrors `requests` but
                      contains only the leaves whose `instances` reference resolves
                      to `"<provider>"` (honoring both `defaultProviderName` /
                      `defaultProvider` and per-instance `instances` overrides).
                      Every declared provider gets an entry, empty when no request
                      routes to it.

                      A provider option's `default` should read its own slice so it
                      gathers only the requests routed to it:

                      ```nix
                      default = config.contracts.${contractName}.providerRequests."<provider>";
                      ```
                    '';
                    type = attrsOf (nestedAttrsOf raw);
                    # For each declared provider, keep the `requests` leaves whose
                    # resolved routing names that provider. `routedName` resolves a
                    # leaf reference to the matching `providers` key by comparing
                    # `module.loc` (cheap to force, unlike the provider's value).
                    # Computed but overridable (like `requests` / `results`) so a
                    # cross-eval bridge can force-inject the containing system's
                    # routing (see `lib/services/lib.nix`).
                    default =
                      let
                        providerNames = lib.attrNames contract.config.providers;
                        routedNames = resolveInstanceTree (_path: routedName);
                      in
                      lib.genAttrs providerNames (
                        providerName:
                        filterNestedAttrs (
                          path: _request: (lib.attrByPath path null routedNames) == providerName
                        ) contract.config.requests
                      );
                    defaultText = lib.literalExpression ''
                      <config.contracts.${contractName}.requests grouped by routed provider name>
                    '';
                  };
                  results = mkOption {
                    description = ''
                      Result data for the `${contractName}` contract, with `request` attributes filtered out.

                      A computed option that extracts the result values from fulfilled contracts.
                      It mirrors `requests` which filters to just request data for providers.

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
                    default =
                      if contract.config.defaultProvider == null && contract.config.want == { } then
                        # No consumers and no provider (e.g. docs sandbox) -- safe empty.
                        { }
                      else
                        lib.mapNestedAttrs' wantType (v: v.result) contract.config.resolvedInstances;
                    defaultText = lib.literalExpression ''
                      lib.mapNestedAttrs' wantType
                        (v: v.result)
                        config.contracts.${contractName}.resolvedInstances
                    '';
                  };
                  mkProviderType = mkOption {
                    description = ''
                      Make the type for an option to provider for the ${contractName} contract.

                      Note that, for options that must work in the sandbox of the NixOS manual builds,
                      one should instead use `(lib.contract.forModule config).${contractName}.mkProviderType`.

                      Unlike `contractDefinitions.${contractName}._mkProviderType`, automatically
                      forwards consumer `want` request data into each leaf at `mkDefault` priority (1000),
                      so provider-specific options do not silently mask consumer `want`s via
                      `nestedAttrsOf` leaf-level priority filtering.

                      `config.contracts.<contract>.mkProviderType :: { providerOptions?, overrides?, fulfill?, fulfill'? } -> optionType`

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
                            # };
                          };
                        };
                        config = {
                          contracts.arithmetic.providers.increment.module = options.services.increment.arithmetic;
                        };
                      }
                      ```
                    '';
                    type = types.functionTo types.optionType;
                    readOnly = true;
                    default = args: contractType._mkProviderType (args // { _requests = contract.config.requests; });
                  };
                };
                # Provide the asserting default for `instances` via config rather
                # than on the option itself: the docs build sandbox evaluates option
                # defaults but does not evaluate submodule config blocks.
                #
                # `defaultProvider` is conventionally a provider reference
                # `{ module, contract? }` (resolved path-aware by
                # `resolvedInstances` / `providerRequests`) but may also be a raw
                # `nestedAttrsOf` tree of pre-resolved instances. Either way: walk
                # each `want`-leaf path and set a `mkOptionDefault`-priority value
                # at that path - either the whole providerRef (resolution picks the
                # per-path slice) or the tree's value at that path. Wrapping each leaf
                # individually (rather than the whole tree) lets per-leaf
                # overrides from other modules compose against the default
                # via `nestedAttrsOf`'s leaf-level priority handling.
                config.instances =
                  let
                    provider = contract.config.defaultProvider;
                    # Walk `want` with explicit recursion (vs.
                    # `concatMapNestedAttrs'` whose `mergeAttrs` fold loses
                    # sibling leaves at depth > 1) to produce a tree mirroring
                    # `want` with `mkOptionDefault`-wrapped leaves - `resolvedInstances` /
                    # `providerRequests` then resolve each leaf path-aware.
                    #
                    # Each leaf's `mkOptionDefault` carries the `defaultProvider`
                    # reference, so a leaf left unset falls back to the default
                    # provider. When there is no `defaultProvider`, the leaf's
                    # default is instead an "unrouted" marker: a per-instance
                    # `instances` override (normal priority) at that leaf wins and
                    # replaces it, so instances-only routing is allowed; a leaf
                    # routed by neither a default nor an override stays unrouted.
                    # This is per-leaf, so the unrouted state never affects leaves
                    # that *are* routed by an override -- unlike a single
                    # whole-tree `assert want == {}`, which rejected any `want` the
                    # moment `defaultProvider` was unset.
                    #
                    # The marker is shaped like a provider reference (`{ module = {
                    # loc; value; }; }`) so it is a leaf to `resolveInstanceTree`
                    # (`v ? module`) without forcing anything: `routedName` forces
                    # only `module.loc` (a sentinel matching no provider, so the
                    # leaf is absent from every `providerRequests` -- routedness is
                    # safe to read), while `resolvedInstances`/`results` force
                    # `module.value` and surface the error -- only when a result
                    # for the unrouted leaf is actually demanded.
                    leafDefault =
                      if provider != null then
                        assert lib.assertMsg (
                          provider ? module
                        ) "contracts.${contractName}.defaultProvider must be a provider reference `{ module, contract? }`.";
                        lib.mkOptionDefault provider
                      else
                        lib.mkOptionDefault {
                          module = {
                            loc = [ "<contracts.${contractName}: unrouted>" ];
                            value = throw "contracts.${contractName}: an instance is `want`ed but routed to no provider. Set `contracts.${contractName}.defaultProvider`/`defaultProviderName`, or route this instance via `contracts.${contractName}.instances`.";
                          };
                        };
                    buildDefaultTree =
                      subWant: if subWant ? request then leafDefault else lib.mapAttrs (_: buildDefaultTree) subWant;
                  in
                  buildDefaultTree contract.config.want;
              }
            );
          }
        ) contractDefinitions;
      };
    };
  };

}
