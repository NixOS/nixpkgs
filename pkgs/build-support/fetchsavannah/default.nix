{ fetchzip }:

# cgit example, snapshot support is optional in cgit
{ repo, rev, name ? "source"
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
  meta.homepage = "https://git.savannah.gnu.org/cgit/${repo}.git/";
} // removeAttrs args [ "repo" "rev" ]) // { inherit rev; }
