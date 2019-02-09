{ fetchzip, lib }:

# gitlab example
{ owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null
, ... # For hash agility
}@args: fetchzip (
let
  repo-url = "https://${domain}/${lib.optionalString (group != null) "${group}/"}${owner}/${repo}/";
in {
  inherit name;
  url = "${repo-url}-/archive/${rev}/${repo}.${rev}.tar.gz";
  meta.homepage = repo-url;
} // removeAttrs args [ "domain" "owner" "group" "repo" "rev" ]) // { inherit rev; }
