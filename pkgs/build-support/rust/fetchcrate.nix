{
  lib,
  fetchzip,
  fetchurl,
}:

{
  crateName ? args.pname,
  pname ? null,
  # The `dl` field of the registry's index configuration
  # https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
  registryDl ? "https://crates.io/api/v1/crates",
  version,
  unpack ? true,
  ...
}@args:

assert pname == null || pname == crateName;

(if unpack then fetchzip else fetchurl) (
  {
    name = "${crateName}-${version}.tar.gz";
    url = "${registryDl}/${crateName}/${version}/download";

    passthru = { inherit pname version; };
  }
  // lib.optionalAttrs unpack {
    extension = "tar.gz";
  }
  // removeAttrs args [
    "crateName"
    "pname"
    "registryDl"
    "version"
    "unpack"
  ]
)
