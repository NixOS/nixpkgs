{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:
<<<<<<< HEAD
let
  # Here defines fetchFromGitHub arguments that determines useFetchGit,
  # The attribute value is their default values.
  # As fetchFromGitHub prefers fetchzip for hash stability,
  # `defaultFetchGitArgs` attributes should lead to `useFetchGit = false`.
  useFetchGitArgsDefault = {
    deepClone = false;
    fetchSubmodules = false; # This differs from fetchgit's default
    fetchLFS = false;
    forceFetchGit = false;
    leaveDotGit = null;
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

  adjustFunctionArgs = f: lib.setFunctionArgs f (faUseFetchGit // lib.functionArgs f);

  decorate = f: lib.makeOverridable (adjustFunctionArgs f);
in
decorate (
=======

lib.makeOverridable (
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  {
    owner,
    repo,
    tag ? null,
    rev ? null,
    # TODO(@ShamrockLee): Add back after reconstruction with lib.extendMkDerivation
    # name ? repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) "github",
<<<<<<< HEAD
    private ? false,
=======
    fetchSubmodules ? false,
    leaveDotGit ? null,
    deepClone ? false,
    private ? false,
    forceFetchGit ? false,
    fetchLFS ? false,
    rootDir ? "",
    sparseCheckout ? lib.optional (rootDir != "") rootDir,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    githubBase ? "github.com",
    varPrefix ? null,
    passthru ? { },
    meta ? { },
<<<<<<< HEAD
    ... # For hash agility and additional fetchgit arguments
=======
    ... # For hash agility
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromGitHub requires one of either `rev` or `tag` to be provided (not both)."
  );

  let
<<<<<<< HEAD
    useFetchGit =
      lib.mapAttrs (
        name: nonNullDefault:
        if args ? ${name} && (useFetchGitArgsDefaultNullable ? ${name} -> args.${name} != null) then
          args.${name}
        else
          nonNullDefault
      ) useFetchGitargsDefaultNonNull != useFetchGitargsDefaultNonNull;

    useFetchGitArgsWDPassing = lib.overrideExisting (removeAttrs useFetchGitArgsDefault excludeUseFetchGitArgNames) args;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    position = (
      if args.meta.description or null != null then
        builtins.unsafeGetAttrPos "description" args.meta
      else if tag != null then
        builtins.unsafeGetAttrPos "tag" args
      else
        builtins.unsafeGetAttrPos "rev" args
    );
    baseUrl = "https://${githubBase}/${owner}/${repo}";
    newMeta =
      meta
      // {
        homepage = meta.homepage or baseUrl;
      }
      // lib.optionalAttrs (position != null) {
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        position = "${position.file}:${toString position.line}";
      };
<<<<<<< HEAD
    passthruAttrs = removeAttrs args (
      [
        "owner"
        "repo"
        "tag"
        "rev"
        "private"
        "githubBase"
        "varPrefix"
      ]
      ++ (if useFetchGit then excludeUseFetchGitArgNames else lib.attrNames faUseFetchGit)
    );
    varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
=======
    passthruAttrs = removeAttrs args [
      "owner"
      "repo"
      "tag"
      "rev"
      "fetchSubmodules"
      "forceFetchGit"
      "private"
      "githubBase"
      "varPrefix"
    ];
    varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
    useFetchGit =
      fetchSubmodules
      || (leaveDotGit == true)
      || deepClone
      || forceFetchGit
      || fetchLFS
      || (rootDir != "")
      || (sparseCheckout != [ ]);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetcher =
      if useFetchGit then
        fetchgit
      # fetchzip may not be overridable when using external tools, for example nix-prefetch
      else if fetchzip ? override then
        fetchzip.override { withUnzip = false; }
      else
        fetchzip;
    privateAttrs = lib.optionalAttrs private {
      netrcPhase =
        # When using private repos:
        # - Fetching with git works using https://github.com but not with the GitHub API endpoint
        # - Fetching a tarball from a private repo requires to use the GitHub API endpoint
        let
          machineName = if githubBase == "github.com" && !useFetchGit then "api.github.com" else githubBase;
        in
        ''
          if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
            echo "Error: Private fetchFromGitHub requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
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
    };

    gitRepoUrl = "${baseUrl}.git";

    fetcherArgs =
      finalAttrs:
      passthruAttrs
      // (
        if useFetchGit then
<<<<<<< HEAD
          useFetchGitArgsWDPassing
          // {
            inherit tag rev;
=======
          {
            inherit
              tag
              rev
              deepClone
              fetchSubmodules
              sparseCheckout
              fetchLFS
              ;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
            url = gitRepoUrl;
            inherit passthru;
            derivationArgs = {
              inherit
                githubBase
                owner
                repo
                ;
            };
          }
<<<<<<< HEAD
=======
          // lib.optionalAttrs (leaveDotGit != null) { inherit leaveDotGit; }
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        else
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
              inherit gitRepoUrl;
            }
            // passthru;
          }
      )
      // privateAttrs
      // {
        # TODO(@ShamrockLee): Change back to `inherit name;` after reconstruction with lib.extendMkDerivation
        name =
          args.name
            or (repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) "github");
        meta = newMeta;
      };
  in

  fetcher fetcherArgs
)
