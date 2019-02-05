{ fetchzip }:

# cgit example, snapshot support is optional in cgit
{ repo, rev, name ? "source"
, postFetch ? "", zipPostFetch ? null, zipExtraPostFetch ? ""
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
  ${if zipPostFetch != null then "postFetch" else null} = zipPostFetch;
  extraPostFetch = postFetch + "\n" + zipExtraPostFetch;
} // removeAttrs args [ "repo" "rev" ]) // {
  meta.homepage = "https://git.savannah.gnu.org/cgit/${repo}.git/";
  inherit rev;
}
