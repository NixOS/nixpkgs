{ fetchzip, lib }:

# gitlab example
{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://${domain}/api/v4/projects/${lib.optionalString (group != null) "${lib.replaceStrings ["."] ["%2E"] group}%2F"}${lib.replaceStrings ["."] ["%2E"] owner}%2F${lib.replaceStrings ["."] ["%2E"] repo}/repository/archive.tar.gz?sha=${rev}";
  meta.homepage = "https://${domain}/${lib.optionalString (group != null) "${group}/"}${owner}/${repo}/";
} // removeAttrs args [ "domain" "owner" "group" "repo" "rev" ]) // { inherit rev; }
