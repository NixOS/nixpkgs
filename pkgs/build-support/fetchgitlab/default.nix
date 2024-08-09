{ lib, fetchgit, fetchzip }:

lib.makeOverridable (
# gitlab example
{ owner, repo, rev, protocol ? "https", domain ? "gitlab.com", name ? "source", group ? null
, fetchSubmodules ? false, leaveDotGit ? false
, deepClone ? false, forceFetchGit ? false
, sparseCheckout ? []
, private ? false, varPrefix ? null
, ... # For hash agility
} @ args:

let
  slug = lib.concatStringsSep "/" ((lib.optional (group != null) group) ++ [ owner repo ]);
  escapedSlug = lib.replaceStrings [ "." "/" ] [ "%2E" "%2F" ] slug;
  escapedRev = lib.replaceStrings [ "+" "%" "/" ] [ "%2B" "%25" "%2F" ] rev;
  passthruAttrs = removeAttrs args [ "protocol" "domain" "owner" "group" "repo" "rev" "fetchSubmodules" "forceFetchGit" "private" "varPrefix" "leaveDotGit" "deepClone" ];

  varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_GITLAB_PRIVATE_";
  useFetchGit = fetchSubmodules || leaveDotGit || deepClone || forceFetchGit || (sparseCheckout != []);
  fetcher = if useFetchGit then fetchgit else fetchzip;

  privateAttrs = lib.optionalAttrs private (
    lib.throwIfNot (protocol == "https")
    "private token login is only supported for https" {
      netrcPhase = ''
        if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
          echo "Error: Private fetchFromGitLab requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
          exit 1
        fi
      '' + (if useFetchGit then
      # GitLab supports HTTP Basic Authentication only when Git is used:
      # https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#project-access-tokens
      ''
        cat > netrc <<EOF
        machine ${domain}
                login ''$${varBase}USERNAME
                password ''$${varBase}PASSWORD
        EOF
      ''
      else
      # Access via the GitLab API requires a custom header and does not work
      # with HTTP Basic Authentication:
      # https://docs.gitlab.com/ee/api/#personalprojectgroup-access-tokens
      ''
        # needed because fetchurl always sets --netrc-file if a netrcPhase is present
        touch netrc

        cat > private-token <<EOF
        PRIVATE-TOKEN: ''$${varBase}PASSWORD
        EOF
        curlOpts="$curlOpts --header @./private-token"
      '');
      netrcImpureEnvVars = [ "${varBase}USERNAME" "${varBase}PASSWORD" ];
    });

  gitRepoUrl = "${protocol}://${domain}/${slug}.git";

  fetcherArgs = (if useFetchGit then {
    inherit rev deepClone fetchSubmodules sparseCheckout leaveDotGit;
    url = gitRepoUrl;
  } else {
    url = "${protocol}://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${escapedRev}";

    passthru = {
      inherit gitRepoUrl;
    };
  }) // privateAttrs // passthruAttrs // { inherit name; };
in

fetcher fetcherArgs // { meta.homepage = "${protocol}://${domain}/${slug}/"; inherit rev owner repo; }
)
