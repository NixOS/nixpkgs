{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:
let
  # Here defines fetchFromGitHub arguments that determines useFetchGit,
  # The attribute value is their default values.
  # As fetchFromGitHub prefers fetchzip for hash stability,
  # `getDefaultUseFetchGitArgs { }` attributes should lead to `useFetchGit = false`.
  getDefaultUseFetchGitArgs =
    args:
    let
      argsWithDefault = defaults // args;
      defaults = {
        fetchSubmodules = false; # This differs from fetchgit's default
        leaveDotGit = null;
        deepClone = false;
        forceFetchGit = false;
        fetchLFS = false;
        rootDir = "";
        sparseCheckout = lib.optional (argsWithDefault.rootDir != "") argsWithDefault.rootDir;
      };
    in
    defaults;

  defaultUseFetchGitArgsNeg = getDefaultUseFetchGitArgs { };

  # useFetchGitArgsWD to exclude from automatic passing.
  # Other useFetchGitArgsWD will pass down to fetchgit.
  excludeUseFetchGitArgNames = [
    "forceFetchGit"
    "leaveDotGit"
  ];

  faUseFetchGit = lib.mapAttrs (_: _: true) defaultUseFetchGitArgsNeg;

  faFetchGit = lib.functionArgs fetchgit;
  faFetchZip = lib.functionArgs fetchzip;

  adjustFunctionArgs =
    let
      faAdding =
        removeAttrs (faFetchGit // faFetchZip // removeAttrs faUseFetchGit excludeUseFetchGitArgNames)
          [
            "outputHashAlgo"
            "outputHash"
            "sha1"
            "sha256"
            "sha512"
          ];
    in
    f: lib.setFunctionArgs f (faAdding // lib.functionArgs f);

  decorate = f: lib.makeOverridable (adjustFunctionArgs f);
in
decorate (
  {
    owner,
    repo,
    tag ? null,
    rev ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "github",
    private ? false,
    githubBase ? "github.com",
    varPrefix ? null,
    passthru ? { },
    meta ? { },
    ... # For hash agility and additional fetchgit arguments
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromGitHub requires one of either `rev` or `tag` to be provided (not both)."
  );

  let
    useFetchGit =
      let
      in
      useFetchGitArgsWD.forceFetchGit
      || useFetchGitArgsWD.leaveDotGit == true
      || useFetchGitArgs != lib.intersectAttrs useFetchGitArgs defaultUseFetchGitArgsNeg;

    useFetchGitArgs = lib.intersectAttrs faUseFetchGit args;
    useFetchGitArgsDefault = getDefaultUseFetchGitArgs args;
    useFetchGitArgsWD = useFetchGitArgsDefault // useFetchGitArgs;
    useFetchGitArgsWDAutoPassing = removeAttrs useFetchGitArgsWD excludeUseFetchGitArgNames;

    useFetchGitArgsWDPassing =
      useFetchGitArgsWDAutoPassing
      // lib.optionalAttrs (useFetchGitArgsWD.leaveDotGit != null) {
        inherit (useFetchGitArgsWD) leaveDotGit;
      };

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

    revWithTag = if tag != null then "refs/tags/${tag}" else rev;

    fetcherArgs =
      passthruAttrs
      // (
        if useFetchGit then
          useFetchGitArgsWDPassing
          // {
            inherit tag rev;
            url = gitRepoUrl;
            inherit passthru;
          }
        else
          {
            # Use the API endpoint for private repos, as the archive URI doesn't
            # support access with GitHub's fine-grained access tokens.
            #
            # Use the archive URI for non-private repos, as the API endpoint has
            # relatively restrictive rate limits for unauthenticated users.
            url =
              if private then
                let
                  endpoint = "/repos/${owner}/${repo}/tarball/${revWithTag}";
                in
                if githubBase == "github.com" then
                  "https://api.github.com${endpoint}"
                else
                  "https://${githubBase}/api/v3${endpoint}"
              else
                "${baseUrl}/archive/${revWithTag}.tar.gz";
            extension = "tar.gz";

            passthru = {
              inherit gitRepoUrl;
            }
            // passthru;
          }
      )
      // privateAttrs
      // {
        inherit name;
      };
  in

  fetcher fetcherArgs
  // {
    meta = newMeta;
    inherit owner repo tag;
    rev = revWithTag;
  }
)
