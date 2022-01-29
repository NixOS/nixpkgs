{ lib, fetchgit, fetchzip }:

{ owner, repo, rev, name ? "source"
, fetchSubmodules ? false, leaveDotGit ? null
, deepClone ? false, private ? false, forceFetchGit ? false
, sparseCheckout ? ""
, githubBase ? "github.com", varPrefix ? null
, ... # For hash agility
}@args:
let
  baseUrl = "https://${githubBase}/${owner}/${repo}";
  passthruAttrs = removeAttrs args [ "owner" "repo" "rev" "fetchSubmodules" "forceFetchGit" "private" "githubBase" "varPrefix" ];
  varBase = "NIX${if varPrefix == null then "" else "_${varPrefix}"}_GITHUB_PRIVATE_";
  useFetchGit = fetchSubmodules || (leaveDotGit == true) || deepClone || forceFetchGit || (sparseCheckout != "");
  # We prefer fetchzip in cases we don't need submodules as the hash
  # is more stable in that case.
  fetcher = if useFetchGit then fetchgit else fetchzip;
  privateAttrs = lib.optionalAttrs private {
    netrcPhase = ''
      if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
        echo "Error: Private fetchFromGitHub requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
        exit 1
      fi
      cat > netrc <<EOF
      machine ${githubBase}
              login ''$${varBase}USERNAME
              password ''$${varBase}PASSWORD
      EOF
    '';
    netrcImpureEnvVars = [ "${varBase}USERNAME" "${varBase}PASSWORD" ];
  };
  fetcherArgs = (if useFetchGit
    then {
      inherit rev deepClone fetchSubmodules sparseCheckout; url = "${baseUrl}.git";
    } // lib.optionalAttrs (leaveDotGit != null) { inherit leaveDotGit; }
    else { url = "${baseUrl}/archive/${rev}.tar.gz"; }
  ) // privateAttrs // passthruAttrs // { inherit name; };
in

fetcher fetcherArgs // { meta.homepage = baseUrl; inherit rev; }
