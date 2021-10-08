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
    version = "91.2.0";
    application = "comm/mail";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      sha512 = "1f21f77069490be2de131f6125a498c6ed0a7d10b2ff787891d8dea10019719fea8014a8b2d626a2365f10f6307b616e5f1eef2c601e4da5402c9d5fc7d35049";
    };
    patches = [
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

  thunderbird-78 = common rec {
    pname = "thunderbird";
    version = "78.14.0";
    application = "comm/mail";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      sha512 = "0zan30jvv45pd6i59l2kfyfjwivqk5qq6vyf77xhss2dk8qhk3mfrfxpfbkrab676l14b9hs09nr6ni1h1iwn82zx5k7fx5x8sh5dx6";
    };
    patches = [
      ./no-buildconfig-78.patch
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
      attrPath = "thunderbird-78-unwrapped";
    };
  };
}
