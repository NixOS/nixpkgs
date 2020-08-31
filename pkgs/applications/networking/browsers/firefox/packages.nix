{ config, stdenv, lib, callPackage, fetchurl, nss_3_44 }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "80.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "081sf41r7ickjij3kfrdq29a0d6wz7qv8950kx116kakh8qxgjy8ahk2mfwlcp6digrl4mimi8rl7ns1wjngsmrjh4lvqzh1xglx9cp";
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

  firefox-esr-68 = (common rec {
    pname = "firefox-esr";
    ffversion = "68.12.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "169y4prlb4mi31jciz89kp35rpb1p2gxrk93qkwfzdk4imi9hk8mi2yvxknpr0rni3bn2x0zgrrc6ccr8swv5895sqvv1sc5r1056w3";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-68-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  }).override {
    # Mozilla unfortunately doesn't support building with latest NSS anymore;
    # instead they provide ESR releases for NSS:
    # https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/NSS_Releases
    nss = nss_3_44;
  };

}
