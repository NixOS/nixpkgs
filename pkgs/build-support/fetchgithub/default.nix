{
  lib,
  fetchFromGitProvider,
}:

lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitProvider.override (previousArgs: {
      fetchzip =
        # fetchzip may not be overridable when using external tools, for example nix-prefetch
        if previousArgs.fetchzip ? override then
          previousArgs.fetchzip.override {
            withUnzip = false;
          }
        else
          previousArgs.fetchzip;
    });

    excludeDrvArgNames = [
      # Pass via derivationArgs
      "githubBase"
      "owner"

      # Private attributes
      # TODO(@ShamrockLee): check if those are still functional.
      "private"
      "varPrefix"
    ];

    extendDrvArgs =
      finalAttrs:
      {
        owner,
        repo,
        tag ? null,
        rev ? null,
        private ? false,
        rootDir ? "",
        githubBase ? "github.com",
        varPrefix ? null,
        passthru ? { },
        meta ? { },
        ... # For hash agility and additional fetchgit arguments
      }@args:

      let

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
        varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
        getPrivateAttrs =
          useFetchGit:
          lib.optionalAttrs private {
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
      in
      {
        providerName = "github";

        derivationArgs = {
          inherit
            githubBase
            owner
            ;
        };

        inherit repo;

        gitRepoUrl = "${baseUrl}.git";

        fetchgitArgs = getPrivateAttrs true;

        fetchzipArgs =
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
          }
          // getPrivateAttrs false;

        meta = newMeta;
      };
  }
)
