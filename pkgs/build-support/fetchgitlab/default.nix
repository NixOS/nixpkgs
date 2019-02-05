{ fetchzip, lib }:

{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null
, postFetch ? "", zipPostFetch ? null, zipExtraPostFetch ? ""
, ... # For hash agility
}@args: let
  passthruAttrs = removeAttrs args [ "domain" "owner" "group" "repo" "rev" "postFetch" "zipPostFetch" "zipExtraPostFetch" ];
  repoPath = lib.optionalString (group != null) "${group}/" + "${owner}/${repo}";
  urlSanitize = lib.replaceStrings ["." "/"] ["%2E" "%2F"];
  fetcherArgs = {
    inherit name;
    url = "https://${domain}/api/v4/projects/${urlSanitize repoPath}/repository/archive.tar.gz?sha=${rev}";
    ${if zipPostFetch != null then "postFetch" else null} = zipPostFetch;
    extraPostFetch = postFetch + "\n" + zipExtraPostFetch;
  } // passthruAttrs;
in fetchzip fetcherArgs // {
  meta.homepage = "https://${domain}/${repoPath}/";
  inherit rev;
}
