{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ../../browsers/firefox/common.nix opts) {
    webrtcSupport = false;
    geolocationSupport = false;
  };
in

rec {
  thunderbird = common rec {
    pname = "thunderbird";
    version = "91.9.1";
    application = "comm/mail";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      sha512 = "997751056ad44367a128aef13ddd55f80798f262644253f814e6e607b3bfc3e33070ed072fa7062586378234cabc7ad106efa26befc3ecb843c5dd02c1498f0f";
    };
    patches = [
      # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
      ./no-buildconfig.patch
    ];

    meta = with lib; {
      description = "A full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      maintainers = with maintainers; [ eelco lovesegfault pierron vcunat ];
      platforms = platforms.unix;
      badPlatforms = platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "thunderbird-unwrapped";
    };
  };
}
