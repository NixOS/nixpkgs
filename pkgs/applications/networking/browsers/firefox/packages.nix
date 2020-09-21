{ config, stdenv, lib, callPackage, fetchurl, nss_3_44 }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "81.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "1dnxn754vb99mccqrj3wr3pg2scjy42rvs5xc6bw022gh6n8kgipx9pbkapwfivkglynxmmbw1k11ak34zhr1g6p31m3550ad6azq19";
    };

    patches = [
      ./no-buildconfig-ffx76.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
      timeout = 28800; # eight hours
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.2.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "1dnvr9nyvnv5dkpnjnadff38lf9r7g37gk401c1i22d661ib5xj0gm2rnz1rjyrkvzrnr6p9f7liy3i41varja00g0x1racccj1my9q";
    };

    patches = [
      ./no-buildconfig-ffx76.patch
    ];

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionKey = "ffversion";
    };
  };
}
