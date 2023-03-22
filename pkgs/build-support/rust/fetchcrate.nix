{ lib, fetchzip, fetchurl }:

{ crateName ? args.pname
, pname ? null
, version
, unpack ? true
, ...
} @ args:

assert pname == null || pname == crateName;

(if unpack then fetchzip else fetchurl) ({
  name = "${crateName}-${version}.tar.gz";
  url = "https://crates.io/api/v1/crates/${crateName}/${version}/download";
} // lib.optionalAttrs unpack {
  extension = "tar.gz";
} // removeAttrs args [ "crateName" "pname" "version" "unpack" ])
