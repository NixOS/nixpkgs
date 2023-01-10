{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

rec {
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "108.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "f856ef034fa4a526e19968aed092c9ee99e124d2d271ec1c1bbd091d9a03e23293d69c7a9ae17c43258cde7e73c294534b471e36441e576377854f607c9bfa3a";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ lovesegfault hexa ];
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

  firefox-esr-102 = buildMozillaMach rec {
    pname = "firefox-esr-102";
    version = "102.6.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "c0f0160bea612d0ae74c29dd44beb7fd9a1c292694b8cd5c4faf2e54feb5c27684eee821b67dd40df714d69866a4e3a8b19e22182d9bc3023050d2d96b02d308";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-esr-102 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-102-unwrapped";
      versionPrefix = "102";
      versionSuffix = "esr";
    };
  };
}
