{ config, stdenv, lib, callPackage, fetchurl, rustPackages_1_44, rustPackages_1_49 }:

let
  commonCP = opts: callPackage (import ./common.nix opts);
in

rec {
  firefox = commonCP rec {
    pname = "firefox";
    ffversion = "88.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "f58f44f2f0d0f54eae5ab4fa439205feb8b9209b1bf2ea2ae0c9691e9e583bae2cbd4033edb5bdf4e37eda5b95fca688499bed000fe26ced8ff4bbc49347ce31";
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
    ffversion = "78.10.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "5e2cf137dc781855542c29df6152fa74ba749801640ade3cf01487ce993786b87a4f603d25c0af9323e67c7e15c75655523428c1c1426527b8623c7ded9f5946";
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
