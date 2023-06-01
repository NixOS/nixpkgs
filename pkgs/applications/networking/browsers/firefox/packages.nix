{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

{
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "113.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "7b1ff7d547fda02901f54a2593e03598a830698192003d833e27b85db0e00571ff66e03ebd4089e76fa65b09df000cbb2542450beeabb0b310875910603e6743";
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

  firefox-beta = buildMozillaMach rec {
    pname = "firefox-beta";
    version = "114.0b7";
    applicationName = "Mozilla Firefox Beta";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "6cfcaa08d74d6e123047cd33c1bc2e012e948890ea8bab5feb43459048a41c10f6bc549241386a3c81d438b59e966e7949161fe3f18b359ec8659bdf2ba0f187";
    };

    meta = {
      description = "A web browser built from Firefox Beta Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ jopejoe1 ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-beta ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-beta-unwrapped";
      versionSuffix = "b[0-9]*";
    };
  };

  firefox-devedition = buildMozillaMach rec {
    pname = "firefox-devedition";
    version = "114.0b7";
    applicationName = "Mozilla Firefox Developer Edition";
    branding = "browser/branding/aurora";
    src = fetchurl {
      url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "2aa9ec2eb57b6debe3a15ac43f4410a4d649c8373725be8ed2540effa758d970e29c9ca675d9ac27a4b58935fc428aaf8b84ecd769b88f3607e911178492ebf1";
    };

    meta = {
      description = "A web browser built from Firefox Developer Edition source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ jopejoe1 ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-devedition ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-devedition-unwrapped";
      versionSuffix = "b[0-9]*";
      baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
    };
  };

  firefox-esr-102 = buildMozillaMach rec {
    pname = "firefox-esr-102";
    version = "102.11.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "fdfed404c87f33001c0ab50f9899fa80c897fac645be8ed832e426f412aafbf1468b1c8301bad463b3f5535b6d6f2005a96a748b6e2d6bf5afbc3b5bc10983d6";
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
