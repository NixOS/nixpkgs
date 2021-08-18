{ fetchgit, fetchzip, lib }:

# gitlab example
{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null
, fetchSubmodules ? false, leaveDotGit ? false, deepClone ? false
, ... # For hash agility
} @ args:

let
  slug = lib.concatStringsSep "/" ((lib.optional (group != null) group) ++ [ owner repo ]);
  escapedSlug = lib.replaceStrings [ "." "/" ] [ "%2E" "%2F" ] slug;
  escapedRev = lib.replaceStrings [ "+" "%" "/" ] [ "%2B" "%25" "%2F" ] rev;
  passthruAttrs = removeAttrs args [ "domain" "owner" "group" "repo" "rev" ];

  useFetchGit = deepClone || fetchSubmodules || leaveDotGit;
  fetcher = if useFetchGit then fetchgit else fetchzip;

  fetcherArgs = (if useFetchGit then {
    inherit rev deepClone fetchSubmodules leaveDotGit;
    url = "https://${domain}/${slug}.git";
  } else {
    url = "https://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${escapedRev}";
  }) // passthruAttrs // { inherit name; };
in

fetcher fetcherArgs // { meta.homepage = "https://${domain}/${slug}/"; inherit rev; }
