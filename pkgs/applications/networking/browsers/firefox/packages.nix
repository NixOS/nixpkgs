{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

{
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "127.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "5a17bce357e7f445c37540115f2c131ad5a055c0cf04f20bc2eaca18f8d241a99ac76739d172b38f2ad2681633f901a0a15893801082ac5db9e20e31fc8b8291";
    };

    extraPatches = [
    ];

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
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  };

  firefox-beta = buildMozillaMach rec {
    pname = "firefox-beta";
    version = "126.0b5";
    applicationName = "Mozilla Firefox Beta";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "5a079e4f01c95baf5b26a5d61521eea493fa4c3cdf91985fbbee313ddc50af1d941915abd6d0ffa97927d80f2016cbdcd3c80c11cfc3068cf83a62f3b45026ad";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
      description = "A web browser built from Firefox Beta Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ jopejoe1 ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox-beta ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-beta-unwrapped";
      versionSuffix = "b[0-9]*";
    };
  };

  firefox-devedition = buildMozillaMach rec {
    pname = "firefox-devedition";
    version = "126.0b5";
    applicationName = "Mozilla Firefox Developer Edition";
    requireSigning = false;
    branding = "browser/branding/aurora";
    src = fetchurl {
      url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "cb36cdf70035ed96cb877d41e499d7df03fc6a939f4a5395fef110a44f7d810ad4e8fa393c784f3e7d286ffde0c4f3ad0fd38e81236a301a24d4e74eece702b1";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
      description = "A web browser built from Firefox Developer Edition source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ jopejoe1 ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox-devedition ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-devedition-unwrapped";
      versionSuffix = "b[0-9]*";
      baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
    };
  };

  firefox-esr-115 = buildMozillaMach rec {
    pname = "firefox-esr-115";
    version = "115.12.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "d98475061d870e0f3aa920b7c0b9b0c1cbdb3f4102f760f1d1c5ea3e45e216c673c8d3662501e7e78af4950a003a519e94b57e9b1eda8d615c159cdf62130e89";
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
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox-esr-115 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-115-unwrapped";
      versionPrefix = "115";
      versionSuffix = "esr";
    };
  };
}
