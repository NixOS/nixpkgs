{ fetchArchive, lib }:

{ url, rev, name ? "source", ... } @ args:

fetchArchive ({
  inherit name;
  url = "${url}/+archive/${rev}.tar.gz";
  stripRoot = false;
  meta.homepage = url;
} // removeAttrs args [ "url" "rev" ]) // { inherit rev; }
