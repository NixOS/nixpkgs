{ config, stdenv, lib, callPackage, fetchurl, rustPackages_1_44, rustPackages_1_49 }:

let
  commonCP = opts: callPackage (import ./common.nix opts);
in

rec {
  firefox = commonCP rec {
    pname = "firefox";
    ffversion = "88.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "e2d7fc950ba49f225c83ee1d799d6318fcf16c33a3b7f40b85c49d5b7865f7e632c703e5fd227a303b56e2565d0796283ebb12d7fd1a02781dcaa45e84cea934";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
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
  }
  { inherit (rustPackages_1_49) cargo rustc; }
  ;

  firefox-esr-78 = commonCP rec {
    pname = "firefox-esr";
    ffversion = "78.11.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "d02fc2eda587155b1c54ca12a6c5cde220a29f41f154f1c9b71ae8f966d8cc9439201a5b241e03fc0795b74e2479f7aa5d6b69f70b7639432e5382f321f7a6f4";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
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
  }
  { inherit (rustPackages_1_44) cargo rustc; }
  ;
}
