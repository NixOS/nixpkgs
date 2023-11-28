{ fetchgit, fetchzip, lib }:

let
  inherit (lib) replaceStrings optional concatStringsSep;
  escapeSlug = replaceStrings [ "." "/" ] [ "%2E" "%2F" ];
  escapeRev = replaceStrings [ "+" "%" "/" ] [ "%2B" "%25" "%2F" ];
  passthruAttrs' = [ "protocol" "domain" "owner" "group" "repo" "rev" "fetchSubmodules" "leaveDotGit" "deepClone" ];

in

lib.makeOverridable (
# gitlab example
{ owner, repo, rev, protocol ? "https", domain ? "gitlab.com", name ? "source", group ? null
, fetchSubmodules ? false, leaveDotGit ? false, deepClone ? false
, ... # For hash agility
} @ args:

let
  slug = concatStringsSep "/" ((optional (group != null) group) ++ [ owner repo ]);
  escapedSlug = escapeSlug slug;
  escapedRev = escapeRev rev;
  passthruAttrs = removeAttrs args passthruAttrs';

  useFetchGit = deepClone || fetchSubmodules || leaveDotGit;
  fetcher = if useFetchGit then fetchgit else fetchzip;

  gitRepoUrl = "${protocol}://${domain}/${slug}.git";

  fetcherArgs = (if useFetchGit then {
    inherit rev deepClone fetchSubmodules leaveDotGit;
    url = gitRepoUrl;
  } else {
    url = "${protocol}://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${escapedRev}";

    passthru = {
      inherit gitRepoUrl;
    };
  }) // passthruAttrs // { inherit name; };
in

fetcher fetcherArgs // { meta.homepage = "${protocol}://${domain}/${slug}/"; inherit rev; }
)
