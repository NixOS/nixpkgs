{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ../../browsers/firefox/common.nix opts) {};
in

rec {
  thunderbird = common rec {
    pname = "thunderbird";
    version = "78.12.0";
    application = "comm/mail";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      sha512 = "8a9275f6a454b16215e9440d8b68926e56221dbb416f77ea0cd0a42853bdd26f35514e792564879c387271bd43d8ee966577f133f8ae7781f43e8bec9ab78696";
    };
    patches = [
      ./no-buildconfig-78.patch
    ];

    meta = {
      description = "A full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      maintainers = with lib.maintainers; [ eelco lovesegfault pierron vcunat];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "thunderbird-78-unwrapped";
    };
  };
}
