{ fetchgit, fetchzip, lib }:

lib.makeOverridable (
  { owner
  , repo
  , rev
  , protocol ? "git"
  , domain ? "shithub.us"
  , name ? "source"
  , leaveDotGit ? false
  , deepClone ? false
  , ... # For hash agility
  } @ args:

  let
    passthruAttrs = removeAttrs args [ "protocol" "domain" "owner" "repo" "rev" "leaveDotGit" "deepClone" ];

    useFetchGit = leaveDotGit || deepClone;
    fetcher = if useFetchGit then fetchgit else fetchzip;

    gitRepoUrl = "${protocol}://${domain}/${owner}/${repo}";

    fetcherArgs = (if useFetchGit then {
      # git9 does not support shallow fetches
      inherit rev leaveDotGit;
      url = gitRepoUrl;
    } else {
      url = "https://${domain}/${owner}/${repo}/${rev}/snap.tar.gz";

      passthru = {
        inherit gitRepoUrl;
      };
    }) // passthruAttrs // { inherit name; };
  in

  fetcher fetcherArgs // { meta.homepage = "https://${domain}/${owner}/${repo}/HEAD/info.html"; inherit rev; }
)
