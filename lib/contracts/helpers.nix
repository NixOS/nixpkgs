{ lib, ... }:
{
  /**
    Whether a value is a contract instance (an attrset with `request` and `result`).

    Useful when an option accepts both a contract type and a plain value
    (e.g. `types.oneOf [ types.path contractType ]` or `types.nullOr contractType`)
    and the consumer needs to branch on which was provided.

    lib.contract.isInstance :: a -> bool

    # Example

    ```nix
    if lib.contract.isInstance cfg.passwordFile
    then cfg.passwordFile.result.path
    else cfg.passwordFile
    ```
  */
  isInstance = v: lib.isAttrs v && v ? result;

  /**
    Rebind every contract's `mkProviderType` against a NixOS module's `config`,
    returning an attrset shaped like `lib.contracts` extended with any
    contracts defined inline on `config.contractDefinitions`.

    This makes for the idiomatic way to access `mkProviderType` for providers subject
    to the sandboxing used in builds of the NixOS manual.
    In other cases, one may instead use `config.contracts.<contract>.mkProviderType`.

    For each contract, prefers the bridge (`config.contracts.<name>.mkProviderType`)
    when available - the bridge pre-binds `_requests` so consumer `want` request
    data is forwarded into each leaf (see `_mkProviderType`'s `_requests`
    parameter in `./definition-type.nix`). Falls back to the pure lib function
    when `config.contracts` is absent (e.g. inside the manual docs build's
    per-module sandbox, where the contracts module is not imported); the lib
    version produces an identical option type shape, only without runtime want
    forwarding, which is irrelevant to rendered docs.

    Use this in provider modules to bind one or more contracts at once,
    including contracts defined inline on `config.contractDefinitions`:

    ```nix
    inherit (lib.contract.forModule config) fileSecrets databaseConnection;
    # then: type = fileSecrets.mkProviderType { ... };
    #       type = databaseConnection.mkProviderType { ... };
    ```

    lib.contract.forModule :: moduleConfig -> { <contractName> = contract; ... }
  */
  forModule =
    moduleConfig:
    let
      contracts = lib.contracts // (moduleConfig.contractDefinitions or { });
    in
    lib.mapAttrs (
      name: contract:
      contract
      // {
        mkProviderType = moduleConfig.contracts.${name}.mkProviderType or contract._mkProviderType;
      }
    ) contracts;

  /**
    Generic skeleton for a contract `behaviorTest`.

    Abstracts the contract-name prefix, want-path wiring, and result extraction,
    leaving only per-contract pieces (test options, request shape, nodeConfig,
    testScript body) to the caller.

    lib.contract.mkBehaviorTest :: { contractName, testName, wantPath, ... } -> NixOSTest

    # Arguments

    - `contractName`: attrset key under `config.contracts` (e.g. `"fileSecrets"`)
    - `testName`: test-name suffix; produces `contracts_<contractName>_<testName>`
    - `wantPath`: attr-path list into `contracts.<contractName>.want`
    - `extraModules`: extra NixOS modules for the test machine (optional, default `[]`)
    - `nodeModule`: NixOS module that defines per-contract `options` and their config
      (e.g. `options.test.*`, user/group autocreation)
    - `requestOf`: `config -> request` - derive the contract request attrset from
      the evaluated node config
    - `testScript`: `{ result, nodes } -> string` - return the Python test script;
      `result` is the already-resolved result attrset for `wantPath`
  */
  mkBehaviorTest =
    {
      contractName,
      testName,
      wantPath,
      extraModules ? [ ],
      nodeModule,
      requestOf,
      testScript,
    }:
    {
      name = "contracts_${contractName}_${testName}";
      nodes.machine =
        { config, ... }:
        {
          imports = extraModules ++ [ nodeModule ];
          config = lib.setAttrByPath (
            [
              "contracts"
              contractName
              "want"
            ]
            ++ wantPath
            ++ [ "request" ]
          ) (requestOf config);
        };
      testScript =
        { nodes, ... }:
        testScript {
          result = lib.getAttrFromPath (
            [
              "contracts"
              contractName
              "results"
            ]
            ++ wantPath
          ) nodes.machine;
          inherit nodes;
        };
    };
}
