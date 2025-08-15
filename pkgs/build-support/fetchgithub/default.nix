{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
  fetchurl,
  jq,
  pure-export-subst,
}:

lib.makeOverridable (
  {
    owner,
    repo,
    tag ? null,
    rev ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "github",
    fetchSubmodules ? false,
    leaveDotGit ? null,
    deepClone ? false,
    private ? false,
    forceFetchGit ? false,
    fetchLFS ? false,
    sparseCheckout ? [ ],
    githubBase ? "github.com",
    varPrefix ? null,
    pureExportSubst ? false,
    meta ? { },
    ... # For hash agility
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromGitHub requires one of either `rev` or `tag` to be provided (not both)."
  );
  # pureExportSubst relies on fetching commit data from GitHub API by tag,
  # and currently doesn't support any options that rely on fetchgit.
  assert
    pureExportSubst
    -> (
      (tag != null)
      && (rev == null)
      && !fetchSubmodules
      && (leaveDotGit == null)
      && !deepClone
      && !forceFetchGit
      && !fetchLFS
      && (sparseCheckout == [ ])
    );

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
      "pureExportSubst"
    ];
    varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITHUB_PRIVATE_";
    useFetchGit =
      fetchSubmodules
      || (leaveDotGit == true)
      || deepClone
      || forceFetchGit
      || fetchLFS
      || (sparseCheckout != [ ]);
    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetcher =
      if useFetchGit then
        fetchgit
      else if pureExportSubst then
        fetchurl
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
      (
        if useFetchGit then
          {
            inherit
              tag
              rev
              deepClone
              fetchSubmodules
              sparseCheckout
              fetchLFS
              ;
            url = gitRepoUrl;
          }
          // lib.optionalAttrs (leaveDotGit != null) { inherit leaveDotGit; }
        else if pureExportSubst then
          let
            apiBase = "https://${
              if githubBase == "github.com" then "api.github.com" else "${githubBase}/api/v3"
            }";
          in
          {
            url = "${apiBase}/repos/${owner}/${repo}/git/refs/tags/${tag}";
            recursiveHash = true;
            downloadToTemp = true;
            nativeBuildInputs = [
              jq
              pure-export-subst
            ];
            postFetch = ''
              set -euo pipefail

              # $downloadedFile contains JSON about ref
              source <(jq -r '.object | "obj_type=" + .type + "\nobj_url=" + .url + "\nobj_sha=" + .sha + "\n"' "$downloadedFile")
              if [ "$obj_type" != "commit" ]; then
                echo "Unexpected obj_type '$obj_type', expected 'commit'."
                exit 1
              fi

              rm "$downloadedFile"
              success=
              tryDownload "$obj_url"
              if ! test -n "$success"; then
                exit 1
              fi
              tree_sha="$(jq -r .tree.sha "$downloadedFile")"
              mv "$downloadedFile" "$TMPDIR/commit.json"

              success=
              tryDownload "${apiBase}/repos/${owner}/${repo}/tarball/$tree_sha"
              if ! test -n "$success"; then
                exit 1
              fi

              unpackDir="$TMPDIR/unpack"
              mkdir "$unpackDir"
              cd "$unpackDir"
              mv "$downloadedFile" "$downloadedFile.tar.gz"
              unpackFile "$downloadedFile.tar.gz"
              onlyDir="$unpackDir/$(ls -A)"
              cd "$onlyDir"
              pure-export-subst "${tag}" "$TMPDIR/commit.json"
              mv "$onlyDir" "$out"
            '';
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
            };
          }
      )
      // privateAttrs
      // passthruAttrs
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
