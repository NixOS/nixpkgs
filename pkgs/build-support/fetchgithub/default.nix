{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}@args:
let
  inherit (lib)
    all
    attrNames
    functionArgs
    intersectAttrs
    makeOverridable
    mapAttrs
    optionalAttrs
    optionalString
    revOrTag
    setFunctionArgs
    unsafeGetAttrPos
    ;

  removedPassthruBaseNames = [
    "owner"
    "repo"
    "tag"
    "rev"
    "functionName"
    "private"
    "githubBase"
    "varPrefix"
  ];
  # fetchZipDefaults to exclude from automatic passing.
  # Other fetchZipDefaults will pass down to fetchgit.
  excludedFetchGitArgs = [
    "forceFetchGit"
  ];

  removedPassthruFetchGitNames = removedPassthruBaseNames ++ excludedFetchGitArgs;
  removedPassthruFetchZipNames = removedPassthruBaseNames ++ attrNames fetchZipDefaults;

  # Here defines fetchFromGitHub arguments that determines useFetchZip,
  # The attribute value is their default values.
  # As fetchFromGitHub prefers fetchzip for hash stability,
  # `fetchZipDefaults` attributes should lead to `useFetchZip = true`.
  fetchZipDefaults = {
    deepClone = false;
    fetchSubmodules = false; # This differs from fetchgit's default
    fetchLFS = false;
    forceFetchGit = false;
    leaveDotGit = false;
    postCheckout = "";
    rootDir = "";
    sparseCheckout = [ ];
  };
  fetchZipNullableArgs = {
    leaveDotGit = null;
    sparseCheckout = null;
  };
  fetchZipDefaultsNulled = fetchZipDefaults // fetchZipNullableArgs;

  fetchGitDefaults = removeAttrs fetchZipDefaultsNulled excludedFetchGitArgs;
  fetchGitFunctionArgs = mapAttrs (_: _: true) fetchZipDefaults;

  adjustFunctionArgs = f: setFunctionArgs f (fetchGitFunctionArgs // functionArgs f);

  decorate = f: makeOverridable (adjustFunctionArgs f);

  # fetchzip may not be overridable when using external tools, for example nix-prefetch
  fetchzip =
    if args.fetchzip ? override then args.fetchzip.override { withUnzip = false; } else args.fetchzip;
in
decorate (
  {
    owner,
    repo,
    tag ? null,
    rev ? null,
    functionName ? "fetchFromGitHub",
    # TODO(@ShamrockLee): Add back after reconstruction with lib.extendMkDerivation
    # name ? repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) "github",
    private ? false,
    githubBase ? "github.com",
    varPrefix ? null,
    passthru ? { },
    meta ? { },
    ... # For hash agility and additional fetchgit arguments
  }@args:

  assert
    (tag == null) != (rev == null)
    || throw "${functionName} requires one of either `rev` or `tag` to be provided (not both).";

  let
    useFetchZip = all (
      arg:
      # this argument doesn't matter for choosing fetchzip/fetchgit
      !fetchZipDefaults ? ${arg}
      # or it's equal to the fetchzip default
      || fetchZipDefaults.${arg} == args.${arg}
      # or it's null and therefore ignored
      || (args.${arg} == null && fetchZipNullableArgs ? ${arg})
    ) (attrNames args);

    position = (
      if args.meta.description or null != null then
        unsafeGetAttrPos "description" args.meta
      else if tag != null then
        unsafeGetAttrPos "tag" args
      else
        unsafeGetAttrPos "rev" args
    );
    baseUrl = "https://${githubBase}/${owner}/${repo}";
    varBase = "NIX${optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
  in
  # We prefer fetchzip in cases we don't need submodules as the hash
  # is more stable in that case.
  (if useFetchZip then fetchzip else fetchgit) (
    finalAttrs:
    removeAttrs args (
      if useFetchZip then removedPassthruFetchZipNames else removedPassthruFetchGitNames
    )
    // (
      if useFetchZip then
        let
          revWithTag = finalAttrs.rev;
        in
        {
          # Use the API endpoint for private repos, as the archive URI doesn't
          # support access with GitHub's fine-grained access tokens.
          #
          # Use the archive URI for non-private repos, as the API endpoint has
          # relatively restrictive rate limits for unauthenticated users.
          url =
            if private then
              let
                endpoint = "/repos/${finalAttrs.owner}/${finalAttrs.repo}/tarball/${revWithTag}";
              in
              if githubBase == "github.com" then
                "https://api.github.com${endpoint}"
              else
                "https://${githubBase}/api/v3${endpoint}"
            else
              "${baseUrl}/archive/${revWithTag}.tar.gz";
          extension = "tar.gz";
          derivationArgs = {
            inherit
              githubBase
              owner
              repo
              tag
              ;
            rev = fetchgit.getRevWithTag {
              inherit (finalAttrs) tag;
              rev = finalAttrs.revCustom;
            };
            revCustom = rev;
          };
          passthru = {
            gitRepoUrl = "${baseUrl}.git";
          }
          // passthru;
        }
      else
        fetchGitDefaults
        // intersectAttrs fetchGitDefaults args
        // {
          inherit tag rev;
          url = "${baseUrl}.git";
          inherit passthru;
          derivationArgs = {
            inherit
              githubBase
              owner
              repo
              ;
          };
        }
    )
    // optionalAttrs private {
      netrcPhase =
        # When using private repos:
        # - Fetching with git works using https://github.com but not with the GitHub API endpoint
        # - Fetching a tarball from a private repo requires to use the GitHub API endpoint
        let
          machineName = if githubBase == "github.com" && useFetchZip then "api.github.com" else githubBase;
        in
        ''
          if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
            echo "Error: Private ${functionName} requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
            exit 1
          fi
          cat > netrc <<EOF
          machine ${machineName}
                  login ''$${varBase}USERNAME
                  password ''$${varBase}PASSWORD
          EOF
        '';
      netrcImpureEnvVars = [
        "${varBase}USERNAME"
        "${varBase}PASSWORD"
      ];
    }
    // {
      # TODO(@ShamrockLee): Change back to `inherit name;` after reconstruction with lib.extendMkDerivation
      name =
        args.name
          or (repoRevToNameMaybe finalAttrs.repo (revOrTag finalAttrs.revCustom finalAttrs.tag) "github");
      meta = meta // {
        homepage = meta.homepage or baseUrl;
        identifiers = {
          purlParts =
            if githubBase == "github.com" then
              {
                type = "github";
                # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/github-definition.md
                spec = "${owner}/${repo}@${(revOrTag rev tag)}";
              }
            else
              {
                type = "generic";
                # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/generic-definition.md
                spec = "${repo}?vcs_url=https://${githubBase}/${owner}/${repo}@${(revOrTag rev tag)}";
              };
        }
        // meta.identifiers or { };
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        ${if position != null then "position" else null} = "${position.file}:${toString position.line}";
      };
    }
  )
)
