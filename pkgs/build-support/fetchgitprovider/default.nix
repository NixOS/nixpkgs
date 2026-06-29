{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}@args:
let
  # Here defines fetchFromGitProvider arguments that determines useFetchGit,
  # The attribute value is their default values.
  # As fetchFromGitProvider prefers fetchzip for hash stability,
  # `defaultFetchGitArgs` attributes should lead to `useFetchGit = false`.
  useFetchGitArgsDefault = {
    deepClone = false;
    fetchSubmodules = false; # This differs from fetchgit's default
    fetchLFS = false;
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

  useFetchGitargsDefaultNonNull = useFetchGitArgsDefault // useFetchGitArgsDefaultNullable;

  # useFetchGitArgsWD to exclude from automatic passing.
  # Other useFetchGitArgsWD will pass down to fetchgit.
  excludeUseFetchGitArgNames = [
    "forceFetchGit"
  ];

  faUseFetchGit = lib.mapAttrs (_: _: true) useFetchGitArgsDefault;

  # fetchzip may not be overridable when using external tools, for example nix-prefetch
  fetchzip =
    if args.fetchzip ? override then args.fetchzip.override { withUnzip = false; } else args.fetchzip;

  nullIfNot = condition: if condition then v: v else v: null;
in
lib.extendMkDerivation rec {
  constructDrv = {
    __functor =
      self: fpArgsExtended:
      let
        blankArgs = lib.mapAttrs (n: v: null) (lib.filterAttrs (n: v: !v) (lib.functionArgs extendDrvArgs));
        inherit (fpArgsExtended blankArgs) useFetchGit;
        # We prefer fetchzip in cases we don't need submodules as the hash
        # is more stable in that case.
        fetcher = if useFetchGit then fetchgit else fetchzip;
      in
      fetcher (finalAttrs: lib.removeAttrs (fpArgsExtended finalAttrs) [ "useFetchGit" ]);
    __functionArgs = lib.functionArgs fetchzip // lib.functionArgs fetchgit // faUseFetchGit;
  };

  excludeDrvArgNames = [
    "owner"
    "repo"
    "tag"
    "rev"
    "providerName"
    "functionName"
    "private"
    "domain"
    "netrcMachineName"
    "varBase"
    "varPrefix"
    "browsableUrl"
    "archiveUrl"
    "gitRepoUrl"
    "derivationArgs"
  ]
  ++ (lib.attrNames faUseFetchGit);

  extendDrvArgs =
    finalAttrs:
    {
      owner,
      repo,
      tag ? null,
      rev ? null,
      providerName,
      functionName ? "fetchFrom${finalAttrs.providerName}",
      name ? repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) (
        lib.toLower finalAttrs.providerName
      ),
      private ? false,
      domain,
      varPrefix ? null,
      varBase ? "NIX${
        lib.optionalString (finalAttrs.varPrefix != null) "_${finalAttrs.varPrefix}"
      }_${lib.toUpper finalAttrs.providerName}_PRIVATE_",
      netrcMachineName ? finalAttrs.domain,
      browsableUrl ? "",
      archiveUrl,
      gitRepoUrl ? "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}.git",
      passthru ? { },
      meta ? { },
      derivationArgs ? { },
      ... # For hash agility and additional fetchgit arguments
    }@args:

    let
      useFetchGit =
        # Check forceFetchGit first
        # so that other useFetchGitArgs could reference finalAttrs
        # with `forceFetchGit = true`.
        args.forceFetchGit or false
        ||
          lib.mapAttrs (
            name: nonNullDefault:
            if args ? ${name} && (useFetchGitArgsDefaultNullable ? ${name} -> args.${name} != null) then
              args.${name}
            else
              nonNullDefault
          ) useFetchGitargsDefaultNonNull != useFetchGitargsDefaultNonNull;

      useFetchGitArgsWDPassing = lib.overrideExisting (removeAttrs useFetchGitArgsDefault excludeUseFetchGitArgNames) args;

      position = (
        if args.meta.description or null != null then
          builtins.unsafeGetAttrPos "description" args.meta
        else if tag != null then
          builtins.unsafeGetAttrPos "tag" args
        else
          builtins.unsafeGetAttrPos "rev" args
      );
      newMeta =
        meta
        // {
          ${if browsableUrl != "" then "homepage" else null} = meta.homepage or browsableUrl;
          identifiers = {
            purlParts = {
              type = "generic";
              # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/generic-definition.md
              spec = "${finalAttrs.repo}?vcs_url=https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}@${(lib.revOrTag finalAttrs.revCustom finalAttrs.tag)}";
            };
          }
          // meta.identifiers or { };
        }
        // lib.optionalAttrs (position != null) {
          # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
          position = "${position.file}:${toString position.line}";
        };
      privateAttrs = {
        netrcPhase =
          args.netrcPhase or (
            # When using private repos:
            # - Fetching with git works using https://github.com but not with the GitHub API endpoint
            # - Fetching a tarball from a private repo requires to use the GitHub API endpoint
            nullIfNot finalAttrs.private ''
              if [ -z "''$${finalAttrs.varBase}USERNAME" -o -z "''$${finalAttrs.varBase}PASSWORD" ]; then
                echo "Error: Private ${functionName} requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
                exit 1
              fi
              cat > netrc <<EOF
              machine $netrcMachineName
                      login ''$${finalAttrs.varBase}USERNAME
                      password ''$${finalAttrs.varBase}PASSWORD
              EOF
            ''
          );
        netrcImpureEnvVars =
          args.netrcImpureEnvVars or (lib.optionals finalAttrs.private [
            "${finalAttrs.varBase}USERNAME"
            "${finalAttrs.varBase}PASSWORD"
          ]);
      };

      derivationArgsCommon = {
        inherit
          domain
          netrcMachineName
          owner
          private
          providerName
          repo
          useFetchGit
          varBase
          varPrefix
          ;
      };

      fetcherArgs =
        let
          handleRevWithTag = lib.throwIfNot (lib.xor (finalAttrs.tag == null) (
            finalAttrs.revCustom == null
          )) "${functionName} requires one of either `rev` or `tag` to be provided (not both).";
        in
        (
          if useFetchGit then
            useFetchGitArgsWDPassing
            // {
              inherit tag rev;
              url = gitRepoUrl;
              passthru = passthru // {
                __handleRevWithTag = handleRevWithTag;
              };
              derivationArgs = derivationArgsCommon // derivationArgs;
            }
          else
            {
              url = archiveUrl;
              extension = "tar.gz";
              derivationArgs =
                derivationArgsCommon
                // {
                  inherit
                    tag
                    ;

                  rev = handleRevWithTag (
                    fetchgit.getRevWithTag {
                      inherit (finalAttrs) tag;
                      rev = finalAttrs.revCustom;
                    }
                  );
                  revCustom = rev;
                }
                // derivationArgs;
              passthru = {
                inherit gitRepoUrl;
              }
              // passthru;
            }
        )
        // privateAttrs
        // {
          inherit name;
          meta = newMeta;
        };
    in
    fetcherArgs // { inherit useFetchGit; };

  transformDrv =
    drv:
    drv.overrideAttrs (
      finalAttrs: previousAttrs: {
        rev = (previousAttrs.passthru.__handleRevWithTag or lib.id) previousAttrs.rev;
        passthru = removeAttrs previousAttrs.passthru [ "__handleRevWithTag" ];
      }
    );
}
