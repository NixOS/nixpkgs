{
  lib,
  repoRevToNameMaybe,
  stdenvNoCC,
  fetchgit,
  fetchzip,
  # Disable referencing `finalAttrs.fetchGit` by default
  # due to performance overhead (+4% CPU time for `pkgs` evaluation if enabled globally).
  # Switching this on enables aggressive dynamic switching between backends after `<pkg>.overrideAttrs` by default,
  # and also enable manual specifying useFetchGit via `overrideAttrs`.
  enableUseFetchGitFinal ? false,
}:
let
  accumulateConstructorMetadata =
    constructDrv:
    let
      f =
        cM1:
        {
          excludeDrvArgNames,
          extendDrvArgs,
          transformDrv,
          ...
        }@cfg:
        if cM1 ? constructDrv then
          cfg
          // f cM1.constructDrv {
            excludeDrvArgNames = excludeDrvArgNames ++ cM1.excludeDrvArgNames;
            extendDrvArgs =
              finalAttrs: args:
              let
                args' = extendDrvArgs finalAttrs args;
              in
              # Also let extendDrvArgs complete the original work of excludeDrvArgNames,
              # making the performance close to direct-composition.
              removeAttrs args' cM1.excludeDrvArgNames // cM1.extendDrvArgs finalAttrs args';
            transformDrv = drv: transformDrv (cM1.transformDrv drv);
          }
        else
          cfg;
    in
    f constructDrv.constructDrv (
      constructDrv
      // {
        extendDrvArgs =
          finalAttrs: args:
          removeAttrs args constructDrv.excludeDrvArgNames // constructDrv.extendDrvArgs finalAttrs args;
      }
    );

  # Here defines fetchFromGitHub arguments that determines useFetchGit,
  # The attribute value is their default values.
  # As fetchFromGitHub prefers fetchzip for hash stability,
  # `defaultFetchGitArgs` attributes should lead to `useFetchGit = false`.
  useFetchGitArgsDefault = {
    fetchSubmodules = false; # This differs from fetchgit's default
    leaveDotGit = null;
    deepClone = false;
    forceFetchGit = false;
    fetchLFS = false;
    rootDir = "";
    sparseCheckout = null;
  };
  useFetchGitArgsDefaultNullable = {
    leaveDotGit = false;
    sparseCheckout = [ ];
  };

  useFetchGitargsDefaultNonNull = useFetchGitArgsDefault // useFetchGitArgsDefaultNullable;

  excludeUseFetchGitArgNames = [
    "forceFetchGit"
  ];

  faUseFetchGit = lib.mapAttrs (_: _: true) useFetchGitArgsDefault;

  # adjustFunctionArgs = f: lib.setFunctionArgs f (faUseFetchGit // lib.functionArgs f);

  getUseFetchGitResults =
    args:
    let
      useFetchGitArgsWD = lib.overrideExisting useFetchGitArgsDefault args;
      useFetchGitArgsWDNonNull =
        useFetchGitArgsWD
        // lib.mapAttrs (
          name: nonNullDefault: lib.defaultTo nonNullDefault useFetchGitArgsWD.${name}
        ) useFetchGitArgsDefaultNullable;
    in
    {
      inherit useFetchGitArgsWD;
      useFetchGit = useFetchGitArgsWDNonNull != useFetchGitargsDefaultNonNull;
      useFetchGitArgsWDPassing = removeAttrs useFetchGitArgsWD excludeUseFetchGitArgNames;
    };

  faFetchGitSpecific = removeAttrs (lib.functionArgs fetchgit) (
    lib.attrNames (faUseFetchGit // lib.functionArgs fetchzip)
    ++ [
      "sha256"
      "outputHash"
      "outputHashAlgo"
    ]
  );
  faFetchZipSpecific = removeAttrs (lib.functionArgs fetchzip) (
    lib.attrNames (faUseFetchGit // lib.functionArgs fetchgit)
    ++ [
      "sha256"
      "outputHash"
      "outputHashAlgo"
    ]
  );

  excludeDrvArgNamesShared = [
    "providerName"
    "repo"
    "rev"
    "tag"
    "gitRepoUrl"
    "useFetchGit"
    "fetchgitArgs"
    "fetchzipArgs"
  ];

  mirrorArgs = f: lib.setFunctionArgs f (lib.functionArgs (extendDrvArgsShared { }) // faUseFetchGit);

  # We prefer fetchzip in cases we don't need submodules as the hash
  # is more stable in that case.
  choices = {
    fetchgit = accumulateConstructorMetadata (
      lib.extendMkDerivation {
        constructDrv = fetchgit;
        excludeDrvArgNames =
          excludeUseFetchGitArgNames ++ lib.attrNames faFetchZipSpecific ++ excludeDrvArgNamesShared;
        extendDrvArgs = finalAttrs: args: (extendDrvArgsShared finalAttrs args).fetchgitArgs;
      }
    );
    fetchzip = accumulateConstructorMetadata (
      lib.extendMkDerivation {
        constructDrv = fetchzip;
        excludeDrvArgNames =
          lib.attrNames (useFetchGitArgsDefault // faFetchGitSpecific) ++ excludeDrvArgNamesShared;
        extendDrvArgs = finalAttrs: args: (extendDrvArgsShared finalAttrs args).fetchzipArgs;
      }
    );
  };

  excludeDrvArgNamesUnion = lib.uniqueStrings (
    choices.fetchgit.excludeDrvArgNames ++ choices.fetchzip.excludeDrvArgNames
  );

  extendDrvArgsShared =
    finalAttrs:
    {
      name ?
        repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag)
          providerName,
      derivationArgs ? { },
      passthru ? { },
      meta ? { },
      providerName ? "git-provider",
      repo,
      rev ? null,
      tag ? null,
      gitRepoUrl,
      fetchgitArgs ? { },
      fetchzipArgs,
      # Forcefully specify `useFetchGit` value.
      # Don't reference to `finalAttrs` when specifying this,
      # or there will be an infinite recursion.
      useFetchGit ? null,
      ...
    }@args:
    let
      useFetchGitResultsCurrent = getUseFetchGitResults args;
      inherit (useFetchGitResultsCurrent)
        useFetchGitArgsWD
        useFetchGitArgsWDPassing
        ;
    in
    {
      useFetchGitCurrent = lib.defaultTo useFetchGitResultsCurrent.useFetchGit useFetchGit;
      fetchgitArgs =
        fetchgitArgs
        // {
          name = fetchgitArgs.name or name;
          inherit tag rev;
          url = gitRepoUrl;
          derivationArgs = {
            inherit repo;
          }
          // derivationArgs
          // fetchgitArgs.derivationArgs or { }
          // lib.getAttrs excludeUseFetchGitArgNames useFetchGitArgsWD;
          passthru = passthru // fetchgitArgs.passthru or { };
          meta = meta // fetchgitArgs.meta or { };
        }
        // useFetchGitArgsWDPassing;
      fetchzipArgs = fetchzipArgs // {
        name = fetchzipArgs.name or name;
        derivationArgs = {
          inherit
            repo
            tag
            ;
          rev = fetchgit.getRevWithTag {
            inherit (finalAttrs) tag;
            rev = finalAttrs.revCustom;
          };
          revCustom = rev;
        }
        // derivationArgs
        // fetchzipArgs.derivationArgs or { };
        passthru = {
          inherit gitRepoUrl;
        }
        // passthru
        // fetchzipArgs.passthru or { };
        meta = meta // fetchzipArgs.meta or { };
      };
    };
in
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = excludeDrvArgNamesUnion;

  extendDrvArgs =
    finalAttrs:
    mirrorArgs (
      args:
      let
        sharedResult = extendDrvArgsShared finalAttrs args;
        inherit (sharedResult) useFetchGitCurrent;
        # accumulateConstructorMetadata make `extendDrvArg` also produce
        # the `removeAttrs args excludeDrvArgNames` result,
        # so we don't need to do it again.
        fetchgitDerivationArgs = choices.fetchgit.extendDrvArgs finalAttrs args;
        fetchzipDerivationArgs = choices.fetchzip.extendDrvArgs finalAttrs args;
        argsPreFiltered = removeAttrs args excludeDrvArgNamesShared;
        useFetchGitFinal = if enableUseFetchGitFinal then finalAttrs.useFetchGit else useFetchGitCurrent;
        newDerivationArgsChosen =
          if useFetchGitFinal then fetchgitDerivationArgs else fetchzipDerivationArgs;
        newDerivationArgsMixed = fetchgitDerivationArgs // fetchzipDerivationArgs;
        checkArgs =
          if useFetchGitCurrent then
            let
              forbiddenArgNames = lib.attrNames (
                lib.filterAttrs (n: v: faFetchZipSpecific ? ${n} && v != null) argsPreFiltered
              );
            in
            lib.throwIf (forbiddenArgNames != [ ]) ''
              fetchGitProvider: Unexpected arguments for fetchgit: ${lib.concatStringsSep ", " forbiddenArgNames}
                Adjust arguments to use the fetchzip backend instead.
            ''
          else
            let
              forbiddenArgNames = lib.attrNames (
                lib.filterAttrs (n: v: faFetchGitSpecific ? ${n} && v != null) argsPreFiltered
              );
            in
            lib.throwIf (forbiddenArgNames != [ ]) ''
              fetchGitProvider: Unexpected arguments for fetchzip: ${lib.concatStringsSep ", " forbiddenArgNames}
                Adjust arguments to use the fetchgit backend instead.
            '';
      in
      checkArgs (
        if enableUseFetchGitFinal then
          # The final useFetchGitArgs extracted from fetchgitDerivationArgs
          # causes FODs that uses the `fetchzip` backend
          # to allocate both fetchgitDerivationArgs and fetchzipDerivationArgs
          # due to the attribute names being always stict.
          # This is why statically determining newDerivationArgsMixed does not optimise the evaluation.
          #
          # If we land the Nix features proposed in PR NixOS/nix#4090,
          # that unstrict `a` in `(a // b).<b_key>`,
          # we could adjust `fetchgit` to group the attributes needed by `useFetchGitArgs` after the rest of attributes.
          # Together with the static determination of newDerivationArgsMixed,
          # we could make the performance overhead of aggressive dynamic switching negligible
          # and enable it by default.
          lib.mapAttrs (
            n: _:
            if useFetchGitArgsDefault ? ${n} then
              # The final useFetchGitArgs produced by fetchgit.
              fetchgitDerivationArgs.${n}
            else
              newDerivationArgsChosen.${n} or null
          ) newDerivationArgsMixed
          // {
            useFetchGit = (getUseFetchGitResults finalAttrs).useFetchGit;
          }
        else
          newDerivationArgsChosen
      )
    );

  transformDrv =
    drv:
    drv.overrideAttrs (
      finalAttrs: previousAttrs: {
        # Add rev xor tag assertion
        # This rev is revOrTag
        rev =
          lib.throwIfNot (lib.xor (finalAttrs.tag or null == null) (finalAttrs.revCustom or null == null))
            ''
              fetchFromGitProvider requires one of either `rev` or `tag` to be provided (not both).
                For `rev` overriding, override `revCustom` in `<pkg>.overrideAttrs`.
            ''
            previousAttrs.rev;
      }
    );
}
// {
  getUseFetchGit = args: (getUseFetchGitResults args).useFetchGit;
}
