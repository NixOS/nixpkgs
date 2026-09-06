{
  lib,
  repoRevToNameMaybe,
  stdenvNoCC,
  fetchgit,
  fetchzip,
  # Whether the fetchzip backend should come with unzip
  withUnzip ? false,
  # Extra expectDrvArgs for possible derivationArgs
  # to saves attrset allocation for known derivationArgs from downstream builders.
  # This doesn't affect fetchFromGitProvider.expectDrvArgs
  extraExpectDrvArgs ? {
    githubBase = true;
  },
}:
let
  fetchzipWithUnzip =
    # fetchzip may not be overridable when using external tools, for example nix-prefetch
    if fetchzip ? override then
      fetchzip.override {
        inherit withUnzip;
      }
    else
      fetchzip;
in
let
  fetchzip = fetchzipWithUnzip;

  excludeDrvArgNamesShared = [
    "archiveUrl"
    "domain"
    "functionName"
    "githubBase"
    "gitRepoUrl"
    "owner"
    "pos"
    "private"
    "providerName"
    "repo"
    "rev"
    "tag"
    "useFetchGit"
    "varPrefix"
  ];

  # Here defines fetchFromGitProvider arguments that determines useFetchGit,
  # The attribute value is their default values.
  # As fetchFromGitProvider prefers fetchzip for hash stability,
  # `defaultFetchGitArgs` attributes should lead to `useFetchGit = false`.
  useFetchGitArgsDefault = {
    deepClone = false;
    fetchLFS = false;
    fetchSubmodules = false; # This differs from fetchgit's default
    fetchTags = false;
    forceFetchGit = false;
    leaveDotGit = null;
    postCheckout = "";
    rootDir = "";
    sparseCheckout = null;
  };
  useFetchGitArgsDefaultNullable = {
    leaveDotGit = false;
    sparseCheckout = [ ];
  };

  useFetchGitArgsDefaultNonNull = useFetchGitArgsDefault // useFetchGitArgsDefaultNullable;
  useFetchGitArgsDefaultPassing = removeAttrs useFetchGitArgsDefault excludeUseFetchGitArgNames;

  excludeUseFetchGitArgNames = [
    "forceFetchGit"
  ];

  # Add rev xor tag assertion
  checkRevTag =
    rev: tag:
    lib.throwIfNot (lib.xor (rev == null) (tag == null)) ''
      fetchFromGitProvider requires one of either `rev` or `tag` to be provided (not both).
        For `rev` overriding, override `revCustom` in `<pkg>.overrideAttrs`.
    '';

  # extendDrvArgsShared forms arguments to pass down to either of the backend fetchers.
  # Its set pattern shows other argumenst (aside from useFetchGitArgs) accept by fetchFromGitProvider.
  extendDrvArgsShared =
    finalAttrs:
    let
      revWithTag = finalAttrs.rev;
    in
    {
      name ? repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) (
        lib.toLower providerName
      ),
      derivationArgs ? { },
      passthru ? { },
      meta ? { },
      pos ? null,
      functionName ? "fetchFrom${providerName}",
      providerName ? "GitHub",
      # fetchFromGitHub backward compatibility
      domain ?
        if providerName == "GitHub" then
          args.githubBase or "github.com"
        else
          throw "fetchFromGitProvider: domain argument missing",
      owner,
      repo,
      rev ? null,
      tag ? null,
      archiveUrl ? (
        if finalAttrs.private then
          let
            endpoint = "/repos/${finalAttrs.owner}/${finalAttrs.repo}/tarball/${revWithTag}";
          in
          if finalAttrs.domain == "github.com" then
            "https://api.github.com${endpoint}"
          else
            "https://${finalAttrs.domain}/api/v3${endpoint}"
        else
          "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}/archive/${revWithTag}.tar.gz"
      ),
      extension ? "tar.gz",
      gitRepoUrl ? "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}.git",
      private ? false,
      varPrefix ? null,
      ...
    }@args:
    let
      varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
    in
    lib.overrideExisting useFetchGitArgsDefaultPassing args
    // {
      inherit
        name
        rev
        tag
        ;
      derivationArgs = derivationArgs // {
        inherit
          domain
          extension
          owner
          private
          repo
          varPrefix
          ;

        # fetchFromGitHub backward compatibility
        githubBase = if providerName == "GitHub" then finalAttrs.domain else null;

        inherit tag;
        # Pass rev as revWithTag.
        # Attach inital value rev/tag check to it.
        rev = checkRevTag finalAttrs.revCustom finalAttrs.tag fetchgit.getRevWithTag {
          inherit (finalAttrs) tag;
          rev = finalAttrs.revCustom;
        };
        revCustom = rev;

        pos =
          if pos != null then
            pos
          else if args.meta.description or null != null then
            builtins.unsafeGetAttrPos "description" args.meta
          else if tag != null then
            builtins.unsafeGetAttrPos "tag" args
          else
            builtins.unsafeGetAttrPos "rev" args;
      };

      url = if finalAttrs.useFetchGit then gitRepoUrl else archiveUrl;

      netrcPhase =
        if !finalAttrs.private then
          null
        else
          let
            netrcMachineName =
              # When using private repos:
              # - Fetching with git works using https://github.com but not with the GitHub API endpoint
              # - Fetching a tarball from a private repo requires to use the GitHub API endpoint
              if finalAttrs.domain == "github.com" && !finalAttrs.useFetchGit then
                "api.github.com"
              else
                finalAttrs.domain;
          in
          ''
            if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
              echo "Error: Private ${functionName} requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
              exit 1
            fi
            cat > netrc <<EOF
            machine ${netrcMachineName}
                    login ''$${varBase}USERNAME
                    password ''$${varBase}PASSWORD
            EOF
          '';
      netrcImpureEnvVars = lib.optionals finalAttrs.private [
        "${varBase}USERNAME"
        "${varBase}PASSWORD"
      ];

      passthru = {
        inherit gitRepoUrl;
      }
      // passthru;

      meta = meta // {
        homepage = meta.homepage or "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}";
        identifiers = meta.identifiers or { } // {
          purlParts =
            meta.identifiers.purlParts or (
              if finalAttrs.domain == "github.com" then
                {
                  type = "github";
                  # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/github-definition.md
                  spec = "${finalAttrs.owner}/${finalAttrs.repo}@${(lib.revOrTag finalAttrs.revCustom finalAttrs.tag)}";
                }
              else
                {
                  type = "generic";
                  # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/generic-definition.md
                  spec = "${finalAttrs.repo}?vcs_url=${gitRepoUrl}@${(lib.revOrTag finalAttrs.revCustom finalAttrs.tag)}";
                }
            );
        };
      };
    };

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

  expectDrvArgsNew = lib.zipAttrsWith (_: lib.any lib.id) [
    {
      useFetchGit = true;
    }
    (
      let
        derivationArgsNewChoices =
          lib.mapAttrs
            (
              n: useFetchGit:
              (extendDrvArgsShared (pseudoFinalAttrs // { inherit useFetchGit; }) (
                removeAttrs faExtendDrvArgsShared [ "derivationArgs" ]
              )).derivationArgs
            )
            {
              fetchgit = true;
              fetchzip = false;
            };
      in
      lib.mapAttrs (
        n: v: derivationArgsNewChoices.fetchgit ? ${n} && derivationArgsNewChoices.fetchzip ? ${n}
      ) (derivationArgsNewChoices.fetchgit // derivationArgsNewChoices.fetchzip)
    )
    faUseFetchGit
  ];

  expectDrvArgsSimple = lib.zipAttrsWith (_: lib.any lib.id) [
    expectDrvArgsNew
    (lib.zipAttrsWith (_: lib.all lib.id) [
      fetchgit.expectDrvArgs
      fetchzip.expectDrvArgs
    ])
  ];

  expectDrvArgsDynamic = lib.zipAttrsWith (_: lib.any lib.id) [
    expectDrvArgsNew
    fetchgit.expectDrvArgs
    fetchzip.expectDrvArgs
  ];

  expectDrvArgs = expectDrvArgsSimple;

  expectDrvArgsExtended = lib.zipAttrsWith (_: lib.any lib.id) [
    extraExpectDrvArgs
    expectDrvArgs
  ];

  faUseFetchGit = lib.mapAttrs (_: _: true) useFetchGitArgsDefault;

  faFetchGitSpecific = removeAttrs (lib.functionArgs fetchgit) (
    lib.attrNames (
      # faUseFetchGit //
      lib.functionArgs fetchzip
    )
    ++ [
      "sha256"
      "outputHash"
      "outputHashAlgo"
    ]
  );
  faFetchZipSpecific = removeAttrs (lib.functionArgs fetchzip) (
    lib.attrNames (
      # faUseFetchGit //
      lib.functionArgs fetchgit
    )
    ++ [
      "sha256"
      "outputHash"
      "outputHashAlgo"
    ]
  );

  faExtendDrvArgsShared = lib.functionArgs (extendDrvArgsShared { });

  mirrorArgs = f: lib.setFunctionArgs f (faExtendDrvArgsShared // faUseFetchGit);

  reapplyExtendMkDerivation =
    let
      faExtendMkDerivation = lib.functionArgs lib.extendMkDerivation;
    in
    cfg: lib.extendMkDerivation (lib.intersectAttrs faExtendMkDerivation cfg);

  # We prefer fetchzip in cases we don't need submodules as the hash
  # is more stable in that case.
  choices = {
    fetchgit = accumulateConstructorMetadata fetchgitChoiceRawChecked;
    fetchzip = accumulateConstructorMetadata fetchzipChoiceRaw;
  };

  fetchgitChoiceRaw = lib.extendMkDerivation {
    constructDrv = fetchgit;
    excludeDrvArgNames =
      excludeUseFetchGitArgNames ++ lib.attrNames faFetchZipSpecific ++ excludeDrvArgNamesShared;
    extendDrvArgs =
      finalAttrs: args:
      removeAttrs (extendDrvArgsShared finalAttrs args) (lib.attrNames faFetchZipSpecific);
  };

  fetchzipChoiceRaw = lib.extendMkDerivation {
    constructDrv = fetchzip;
    excludeDrvArgNames =
      lib.attrNames (useFetchGitArgsDefault // faFetchGitSpecific) ++ excludeDrvArgNamesShared;
    extendDrvArgs =
      finalAttrs: args:
      removeAttrs (extendDrvArgsShared finalAttrs args) (lib.attrNames faFetchGitSpecific);
  };

  fetchgitChoiceRawChecked = reapplyExtendMkDerivation (
    fetchgitChoiceRaw
    // {
      constructDrv = reapplyExtendMkDerivation (
        fetchgit
        // {
          constructDrv = lib.extendMkDerivation {
            inherit (fetchgit) constructDrv;
            extendDrvArgs = finalAttrs: args: {
              rev = checkRevTag finalAttrs.revCustom finalAttrs.tag args.rev;
            };
          };
        }
      );
    }
  );

  excludeDrvArgNamesUnion = lib.uniqueStrings (
    choices.fetchgit.excludeDrvArgNames ++ choices.fetchzip.excludeDrvArgNames
  );

  fetchFromGitProviderDynamic = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;

    excludeDrvArgNames = excludeDrvArgNamesUnion;

    extendDrvArgs =
      finalAttrs:
      mirrorArgs (
        args:
        let
          expectDrvArgsDownstream =
            if lib.all (n: expectDrvArgsExtended ? ${n}) (lib.attrNames args.derivationArgs or { }) then
              expectDrvArgsExtended
            else
              lib.mapAttrs (n: v: false) args.derivationArgs or { } // expectDrvArgs;
          # accumulateConstructorMetadata make `extendDrvArgs` also produce
          # the `removeAttrs args excludeDrvArgNames` result,
          # so we don't need to do it again.
          fetchgitDerivationArgs = choices.fetchgit.extendDrvArgs (
            finalAttrs // { useFetchGit = true; }
          ) args;
          fetchzipDerivationArgs = choices.fetchzip.extendDrvArgs (
            finalAttrs // { useFetchGit = false; }
          ) args;
          newDerivationArgsChosen =
            if finalAttrs.useFetchGit then fetchgitDerivationArgs else fetchzipDerivationArgs;
          useFetchGitArgsWD = lib.overrideExisting useFetchGitArgsDefault args;
          useFetchGitArgsResolved =
            useFetchGitArgsWD // fetchgit.resolveNullableFetchGitArgs finalAttrs useFetchGitArgsWD;
          useFetchGit =
            (lib.mapAttrs (n: _: finalAttrs.${n}) useFetchGitArgsDefaultNonNull)
            != useFetchGitArgsDefaultNonNull;
        in
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
          if n == "useFetchGit" then
            useFetchGit
          else if useFetchGitArgsDefault ? ${n} then
            # The final useFetchGitArgs produced by fetchgit.
            useFetchGitArgsResolved.${n}
          else
            newDerivationArgsChosen.${n} or args.derivationArgs.${n} or (if n == "env" then { } else null)
        ) expectDrvArgsDownstream
      );

    expectDrvArgs = expectDrvArgsDynamic;
  };
  pseudoFinalAttrs =
    lib.mapAttrs (n: v: throw "fetchFromGitProviderSimple: useFetchGitArgs references finalAttrs.${n}")
      (
        expectDrvArgs
        // {
          finalAttrs = true;
          overrideAttrs = true;
        }
      );
  fetchFromGitProviderSimple =
    fpArgs:
    let
      args = if lib.isFunction fpArgs then fpArgs pseudoFinalAttrs else fpArgs;
      useFetchGit =
        (lib.mapAttrs (n: v: args.${n} or v) useFetchGitArgsDefaultNonNull)
        != useFetchGitArgsDefaultNonNull;
      useFetchGitArgsWD = lib.overrideExisting useFetchGitArgsDefault args;
      useFetchGitArgsResolved =
        useFetchGitArgsWD // fetchgit.resolveNullableFetchGitArgs (args // useFetchGitArgsWD) useFetchGitArgsWD;
    in
    if useFetchGit then
      fetchgitChoiceRawChecked (
        finalAttrs:
        let
          args = if lib.isFunction fpArgs then fpArgs finalAttrs else fpArgs;
        in
        args
        // {
          derivationArgs = args.derivationArgs or { } // {
            inherit useFetchGit;
          };
        }
      )
    else
      fetchzipChoiceRaw (
        finalAttrs:
        let
          args = if lib.isFunction fpArgs then fpArgs finalAttrs else fpArgs;
        in
        args
        // {
          derivationArgs =
            args.derivationArgs or { }
            // useFetchGitArgsResolved
            // {
              inherit useFetchGit;
              env = args.derivationArgs.env or { } // {
                NIX_PREFETCH_GIT_CHECKOUT_HOOK = finalAttrs.postCheckout;
              };
            };
        }
      );
in
fetchFromGitProviderDynamic
// {
  __functor =
    _: fpArgs:
    let
      resultSimple = fetchFromGitProviderSimple fpArgs;
      resultDynamic = fetchFromGitProviderDynamic fpArgs;
    in
    resultSimple // { inherit (resultDynamic) overrideAttrs; };
  __functionArgs = lib.functionArgs fetchFromGitProviderDynamic;
  inherit
    expectDrvArgs
    fetchFromGitProviderDynamic
    fetchFromGitProviderSimple
    ;
}
