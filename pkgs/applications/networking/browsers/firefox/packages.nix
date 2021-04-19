{ config, stdenv, lib, callPackage, fetchurl, rustPackages_1_44, rustPackages_1_49 }:

let
  commonCP = opts: callPackage (import ./common.nix opts);
in

rec {
  firefox = commonCP rec {
    pname = "firefox";
    ffversion = "87.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "c1c08be2283e7a162c8be2f2647ec2bb85cab592738dc45e4b4ffb72969229cc0019a30782a4cb27f09a13b088c63841071dd202b3543dfba295140a7d6246a4";
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
