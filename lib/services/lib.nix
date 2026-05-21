{ lib, ... }:
let
  inherit (lib)
    concatLists
    mapAttrsToList
    showOption
    types
    ;
in
rec {
  /**
    Jointly evaluate a set of modular services so their contracts resolve against each other.

    Contract resolution is peer-to-peer across the `services` set.
    As such, this is compatible with environments without a parent evaluation context (e.g. OCI).

    Each service must import the contract-type modules it uses. The helper unions
    contract type definitions across the peer set and handles `want`/`provider` aggregation.

    A service that wants to be the default provider for a contract type sets
    `contracts.<type>.defaultProvider` in its own module.
    If multiple services declare a default for the same type, evaluation fails.

    lib.services.evalServices :: { services: AttrSet } -> AttrSet

    # Inputs

    `services`

    : 1\. An attrset mapping service slot names (strings) to service modules or lists of
      modules. The slot name is each service's identity for contract resolution
      (`want` entries are nested under it in the joint namespace).

    # Example

    ```nix
    let
      portable-lib = import <nixpkgs/lib/services/lib.nix> { inherit lib; };
      result = portable-lib.evalServices {
        services = {
          consumer = ./consumer-service.nix;
          provider = ./provider-service.nix;
        };
      };
    in
    result.contracts.myContract.results.consumer.myOption.someField
    ```
  */
  evalServices =
    { services }:
    let
      toModules = v: if lib.isList v then v else [ v ];

      baseModules =
        name: serviceModules:
        toModules serviceModules
        ++ [
          (lib.modules.importApply ./service.nix {
            pkgs = throw "evalServices: pkgs is not available in this evaluation context";
          })
          { _module.args.name = name; }
        ];

      # Per-service configs without upstream seeding. Used for joint computation
      # (`want`/`providers`/`contractDefinitions`) so that accessing these write-side
      # options does not create a dependency on the joint contracts being resolved.
      baseEvaluated = lib.mapAttrs (
        name: serviceModules:
        (lib.evalModules {
          class = "service";
          modules = baseModules name serviceModules;
        }).config
      ) services;

      # Union of contract type definitions declared across the peer set.
      # Each service must import the contract-type modules it uses so that
      # `contractDefinitions` is populated without depending on `joint`.
      jointContractDefinitions = lib.foldl' (
        acc: service:
        acc // lib.mapAttrs (_: def: { inherit (def) meta interface; }) service.contractDefinitions
      ) { } (lib.attrValues baseEvaluated);

      # Aggregate `want`/`providers`/`defaultProvider` per type across all peers,
      # then resolve via the contracts module's own logic. `want` is nested under
      # each service's slot name to match the `results.<slot>.*` structure.
      joint =
        (lib.evalModules {
          modules = [
            lib.contract.module
            {
              options.meta = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            }
            { contractDefinitions = jointContractDefinitions; }
            (
              { config, ... }:
              {
                contracts = lib.mapAttrs (
                  contractType: _:
                  let
                    # `want` and `defaultProvider` come from `baseEvaluated` (no upstream)
                    # so that collecting them does not force `joint` resolution.
                    perServiceBase = lib.mapAttrsToList (serviceName: service: {
                      inherit serviceName;
                      want = service.contracts.${contractType}.want or { };
                    }) baseEvaluated;
                    # `providers` come from `evaluated` (with upstream) so provider instances
                    # see all consumers' requests when resolving results. Laziness breaks the
                    # apparent mutual dependency: `joint.requests` is computed from `want`
                    # (`baseEvaluated`) and never forces `joint.instances` or `joint.results`.
                    perServiceEval = lib.mapAttrsToList (serviceName: service: {
                      providers = service.contracts.${contractType}.providers or { };
                    }) evaluated;
                    # Detect services that set `defaultProvider` directly. In `baseEvaluated`
                    # (no upstream injection), `defaultProvider` is non-null only when the user
                    # assigned it explicitly. Detection uses `baseEvaluated`; the VALUE is read
                    # from `evaluated` so the provider module's `module.value` reflects
                    # upstream-seeded requests. This does not create a cycle because `evaluated`
                    # does not seed `defaultProvider` from `joint` (only `requests` and `results`
                    # are seeded): the service's own `defaultProvider = providers.increment`
                    # assignment resolves locally within `evaluated` using its seeded `requests`.
                    perServiceDefaultProvider = lib.filter (e: e.detected) (
                      lib.mapAttrsToList (serviceName: service: {
                        inherit serviceName;
                        detected = service.contracts.${contractType}.defaultProvider or null != null;
                      }) baseEvaluated
                    );
                  in
                  {
                    want = lib.listToAttrs (map (e: lib.nameValuePair e.serviceName e.want) perServiceBase);
                    providers = lib.foldl' (acc: e: acc // e.providers) { } perServiceEval;
                  }
                  // lib.optionalAttrs (perServiceDefaultProvider != [ ]) {
                    defaultProvider =
                      assert lib.assertMsg (lib.length perServiceDefaultProvider == 1)
                        "evalServices: multiple services declared `defaultProvider` for `${contractType}`: ${
                          lib.concatMapStringsSep ", " (e: e.serviceName) perServiceDefaultProvider
                        }";
                      (evaluated.${(lib.head perServiceDefaultProvider).serviceName})
                      .contracts.${contractType}.defaultProvider;
                  }
                ) config.contractDefinitions;
              }
            )
          ];
        }).config;

      # Per-service configs, evaluated lazily. Each service's `contracts.*` is
      # seeded from the joint resolution so it reads results by option name directly
      # (no manual prefix). The seed propagates `requests` and `results` from the
      # joint resolution; `defaultProvider` is intentionally NOT seeded so that
      # services which set `defaultProvider = providers.<name>` can be read from
      # `evaluated` in the `perServiceDefaultProvider` block above without creating
      # a cycle (seeding `defaultProvider` from `joint` would depend on `evaluated`
      # which would depend on `joint` again). Write-side options (`want`, `providers`)
      # also remain local to each service.
      #
      # Enumerated over `jointContractDefinitions` (not `joint.contracts`) so that
      # key enumeration does not force joint resolution.
      evaluated = lib.mapAttrs (
        name: serviceModules:
        (lib.evalModules {
          class = "service";
          modules = baseModules name serviceModules ++ [
            {
              config.contracts = lib.mapAttrs (contractType: _: {
                requests = lib.mkForce joint.contracts.${contractType}.requests;
                results = lib.mkForce (joint.contracts.${contractType}.results.${name} or { });
                # Seed the joint routing so a provider whose option `default`
                # reads `providerRequests.<self>` gathers the requests routed
                # to it. The provider registration (`providers`) is local to
                # the service, but routing lives in the joint eval; depends on
                # `joint` only (not `evaluated`), so it is cycle-safe like
                # `requests`.
                providerRequests = lib.mkForce joint.contracts.${contractType}.providerRequests;
              }) jointContractDefinitions;
            }
          ];
        }).config
      ) services;
    in
    {
      services = evaluated;
      contracts = joint.contracts;
    };

  flattenMapServicesConfigToList =
    f: loc: config:
    f loc config
    ++ concatLists (
      mapAttrsToList (
        k: v:
        flattenMapServicesConfigToList f (
          loc
          ++ [
            "services"
            k
          ]
        ) v
      ) config.services
    );

  getWarnings = flattenMapServicesConfigToList (
    loc: config: map (msg: "in ${showOption loc}: ${msg}") config.warnings
  );

  getAssertions = flattenMapServicesConfigToList (
    loc: config:
    map (ass: {
      message = "in ${showOption loc}: ${ass.message}";
      assertion = ass.assertion;
    }) config.assertions
  );

  /**
    Entrypoint for integrating modular services into a containing module system.

    Each containing system (NixOS, ...) calls `configure` to
    obtain a `serviceSubmodule` type for its services option. The returned submodule
    includes the portable service base, contract integration, and any
    service-manager-specific modules passed via `extraRootModules`.

    **Implementing for a new system** (e.g. home-manager, nix-darwin):

    ```nix
    # darwin/modules/services/system.nix
    { lib, config, pkgs, ... }:
    let
      portable-lib = import <nixpkgs/lib/services/lib.nix> { inherit lib; };

      modularServiceConfiguration = portable-lib.configure {
        serviceManagerPkgs = pkgs;
        extraRootModules = [
          ./launchd-service.nix    # launchd-specific options (plist generation, etc.)
        ];
        inherit (config) contracts;
        upstreamContractDefinitions = config.contractDefinitions;
      };
    in
    {
      imports = [
        ./contracts-bridge.nix   # collects want/providers from services (see below)
      ];

      options.services = lib.mkOption {
        type = lib.types.attrsOf modularServiceConfiguration.serviceSubmodule;
        default = { };
      };

      config = {
        # Convert service tree → launchd plists, assertions, etc.
        # (analogous to how NixOS converts to systemd units)
        launchd.agents = ...;
        assertions = ...;
        warnings = ...;
      };
    }
    ```

    The bridge module auto-nests each service's `contracts.<type>.want` entries under
    the service's tree path, then collects them (along with `providers`) into the
    containing system's contract namespace. This prevents collisions between
    independent services. See `nixos/modules/system/service/nixos-contracts-bridge.nix`
    for the reference.

    Services set `contracts.<type>.want`:

    ```nix
    contracts.fileSecrets.want = { inherit (cfg) mySecret; };
    cfg.mySecret.result = config.contracts.fileSecrets.results.mySecret;
    ```

    The bridge handles namespacing transparently.
    Contract state propagates automatically to sub-services at any nesting depth.

    lib.services.configure :: AttrSet -> { serviceSubmodule :: SubmoduleType }

    # Inputs

    `serviceManagerPkgs`

    : A Nixpkgs instance used for built-in logic such as converting
    `configData.<path>.text` to a store path.

    `extraRootModules`

    : Modules to be loaded into the "root" service submodule, but not
    into its sub-`services`. That's the modules' own responsibility.
    Typically contains service-manager-specific option modules
    (e.g. systemd unit options, launchd plist options).

    `extraRootSpecialArgs`

    : Fixed module arguments provided alongside `extraRootModules`.

    `contracts`

    : The containing system's `config.contracts` - injected into each service's
    `contracts.*` options so services can read aggregated results and `defaultProvider`.

    `upstreamContractDefinitions`

    : The containing system's `config.contractDefinitions` - propagated into
    each service's module system so user-defined contract types are available.

    # Output

    An attribute set.

    `serviceSubmodule`: a Module System option type which is a `submodule` with the portable modules and this function's inputs loaded into it.
  */
  configure =
    {
      serviceManagerPkgs,
      extraRootModules ? [ ],
      extraRootSpecialArgs ? { },
      contracts ? { },
      # All NixOS-level contract type definitions (meta + interface), so services
      # can use `contracts.<type>.*` for both lib-level and user-defined contract types.
      upstreamContractDefinitions ? { },
    }:
    let
      # Seeds the service's module system with upstream contract state.
      #
      # Injects resolved `results` and `defaultProvider` from the containing system
      # directly into each service's `contracts.*` options. Results are scoped
      # to this service's namespace so the service can read results via just the
      # option name (no manual prefix needed).
      #
      # Write-side options (`want`, `providers`) remain local to the service.
      # The system's contracts bridge reads these and lifts them to the containing system.
      # A reference implementation for the NixOS case may be found at
      # `nixos/modules/system/service/contracts-bridge.nix`.
      upstreamSeedModule =
        {
          lib,
          name,
          config,
          ...
        }:
        {
          config = {

            # Propagate contract type definitions so user-defined types are available.
            # `mkDefault` lets service-declared definitions take precedence when present.
            contractDefinitions = lib.mkDefault (
              lib.mapAttrs (_: contract: {
                inherit (contract) meta interface;
              }) upstreamContractDefinitions
            );

            # Inject read-side contract options from the containing system,
            # scoped to this service's namespace so the service can read
            # results via just the option name (no manual prefix needed).
            # Enumerate over the service's own `contractDefinitions` (not the full upstream
            # set) so we only inject for types the service actually declares — avoids
            # setting undeclared options and the error-message cycle that would follow.
            contracts = lib.mapAttrs (contractType: _: {
              requests = lib.mkForce contracts.${contractType}.requests;
              results = lib.mkForce (contracts.${contractType}.results.${name} or { });
              defaultProvider = lib.mkForce contracts.${contractType}.defaultProvider;
              # Routing from the containing system, so a provider whose option
              # `default` reads `providerRequests.<self>` gathers its routed
              # requests (the provider registration is local to the service).
              providerRequests = lib.mkForce contracts.${contractType}.providerRequests;
            }) config.contractDefinitions;

          };
        };
      modules = [
        (lib.modules.importApply ./service.nix { pkgs = serviceManagerPkgs; })
      ];
      serviceSubmodule = types.submoduleWith {
        class = "service";
        modules = modules ++ [ upstreamSeedModule ] ++ extraRootModules;
        specialArgs = extraRootSpecialArgs;
      };
    in
    {
      inherit serviceSubmodule;
    };
}
