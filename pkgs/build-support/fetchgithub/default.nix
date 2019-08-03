{ lib, fetchgit, fetchzip }:

{ owner, repo, rev, name ? "source"
, fetchSubmodules ? false, private ? false
, githubBase ? "github.com", varPrefix ? null
, ... # For hash agility
}@args: assert private -> !fetchSubmodules;
let
  baseUrl = "https://${githubBase}/${owner}/${repo}";
  passthruAttrs = removeAttrs args [ "owner" "repo" "rev" "fetchSubmodules" "private" "githubBase" "varPrefix" ];
  varBase = "NIX${if varPrefix == null then "" else "_${varPrefix}"}_GITHUB_PRIVATE_";
  # We prefer fetchzip in cases we don't need submodules as the hash
  # is more stable in that case.
  fetcher = if fetchSubmodules then fetchgit else fetchzip;
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
  fetcherArgs = (if fetchSubmodules
    then { inherit rev fetchSubmodules; url = "${baseUrl}.git"; }
    else ({ url = "${baseUrl}/archive/${rev}.tar.gz"; } // privateAttrs)
  ) // passthruAttrs // { inherit name; };
in fetcher fetcherArgs // { meta.homepage = baseUrl; inherit rev; }
