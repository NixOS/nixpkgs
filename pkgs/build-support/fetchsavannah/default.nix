{ lib, repoRevToNameMaybe, fetchzip }:

lib.makeOverridable (
# cgit example, snapshot support is optional in cgit
{ repo, rev
, name ? repoRevToNameMaybe repo rev "savannah"
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
  meta.homepage = "https://git.savannah.gnu.org/cgit/${repo}.git/";
} // removeAttrs args [ "repo" "rev" ]) // { inherit rev; }
)
