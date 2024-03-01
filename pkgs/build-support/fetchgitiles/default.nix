{ fetchzip, repoRevToNameMaybe, lib }:

lib.makeOverridable (
{ url, rev
, name ? repoRevToNameMaybe url rev "gitiles"
, ...
} @ args:

fetchzip ({
  inherit name;
  url = "${url}/+archive/${rev}.tar.gz";
  stripRoot = false;
  meta.homepage = url;
} // removeAttrs args [ "url" "rev" ]) // { inherit rev; }
)
