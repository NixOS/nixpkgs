{ fetchzip }:

# gitweb example, snapshot support is optional in gitweb
{ repo, rev, name ? "${repo}-${builtins.substring 0 10 rev}"
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
  meta.homepage = "https://repo.or.cz/${repo}.git/";
} // removeAttrs args [ "repo" "rev" ]) // { inherit rev; }
