{ fetchzip, lib }:

# gitlab example
{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null
, ... # For hash agility
} @ args:

with lib;

let
  slug = concatStringsSep "/"
    ((optional (group != null) group) ++ [ owner repo ]);

  escapedSlug = replaceStrings ["." "/"] ["%2E" "%2F"] slug;
in

fetchzip ({
  inherit name;
  url = "https://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${rev}";
  meta.homepage = "https://${domain}/${slug}/";
} // removeAttrs args [ "domain" "owner" "group" "repo" "rev" ]) // { inherit rev; }
