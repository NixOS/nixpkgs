{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    version = "96.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "39f553474537eb4e521f4182e38f0ddff039fa6b40b939d461937d2cef27f7182097b478f08f90d64fdcbe9c063e78f14f6863a8a82a16207ec7a1d3fdfda4ff";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco lovesegfault hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  };

  firefox-esr-91 = common rec {
    pname = "firefox-esr";
    version = "91.4.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "1b9f17c4e58e3753f8507754bba93e3b7f76df5b6845d6173719fbdd98b70af2a90242df42fe274217f56d0280e5dbae17962f5b6bf111421260790f770f5337";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-esr-91 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-91-unwrapped";
      versionSuffix = "esr";
    };
  };
}
