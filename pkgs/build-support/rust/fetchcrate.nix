{ lib, fetchzip }:

{ crateName ? args.pname
, pname ? null
, version
, ...
} @ args:

assert pname == null || pname == crateName;

fetchzip ({
  name = "${crateName}-${version}.tar.gz";
  url = "https://crates.io/api/v1/crates/${crateName}/${version}/download";
  extension = "tar.gz";
} // removeAttrs args [ "crateName" "pname" "version" ])
