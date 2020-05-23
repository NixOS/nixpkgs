{ fetchzip, lib }:

# gitlab example
{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null, token ? null
, ... # For hash agility
} @ args:

with lib;

let
  slug = concatStringsSep "/"
    ((optional (group != null) group) ++ [ owner repo ]);

  escapedSlug = replaceStrings ["." "/"] ["%2E" "%2F"] slug;
  baseURL = "https://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${rev}";
  url = if token == null then "${baseURL}" else "${baseURL}&private_token=${token}";
in

fetchzip ({
  inherit name url;
  meta.homepage = "https://${domain}/${slug}/";
} // removeAttrs args [ "domain" "owner" "group" "repo" "rev" "token" ]) // { inherit rev; }
