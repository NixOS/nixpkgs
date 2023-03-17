{ fetchzip, lib }:

{ url, rev, name ? "source", ... } @ args:

fetchzip ({
  inherit name;
  url = "${url}/+archive/${rev}.tar.gz";
  stripRoot = false;
  meta.homepage = url;
} // removeAttrs args [ "url" "rev" ]) // { inherit rev; }
