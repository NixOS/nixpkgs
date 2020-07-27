{ config, stdenv, lib, callPackage, fetchurl, nss_3_44 }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "79.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "0zgf7wdcz992a4dy1rj0ax0k65an7h9p9iihka3jy4jd7w4g2d0x4mxz5iqn2y26hmgnkvjb921zh28biikahgygqja3z2pcx26ic0r";
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
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.1.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "223v796vjsvgs3yw442c8qbsbh43l1aniial05rl70hx44rh9sg108ripj8q83p5l9m0sp67x6ixd2xvifizv6461a1zra1rvbb1caa";
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
    ffversion = "68.10.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "xcGDNWA2SFHnz46lFlm8T7YCOblgElzbIP4x90LXV//a748xT4ANyRIU7o41gDPcKvlxwIu7pHTvYVixAYgWUw==";
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
