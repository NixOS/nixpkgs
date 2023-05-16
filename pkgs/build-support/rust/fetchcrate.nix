{ lib, fetchzip, fetchurl }:

{ crateName ? args.pname
, pname ? null
<<<<<<< HEAD
  # The `dl` field of the registry's index configuration
  # https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
, registryDl ? "https://crates.io/api/v1/crates"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, version
, unpack ? true
, ...
} @ args:

assert pname == null || pname == crateName;

(if unpack then fetchzip else fetchurl) ({
  name = "${crateName}-${version}.tar.gz";
<<<<<<< HEAD
  url = "${registryDl}/${crateName}/${version}/download";
} // lib.optionalAttrs unpack {
  extension = "tar.gz";
} // removeAttrs args [ "crateName" "pname" "registryDl" "version" "unpack" ])
=======
  url = "https://crates.io/api/v1/crates/${crateName}/${version}/download";
} // lib.optionalAttrs unpack {
  extension = "tar.gz";
} // removeAttrs args [ "crateName" "pname" "version" "unpack" ])
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
