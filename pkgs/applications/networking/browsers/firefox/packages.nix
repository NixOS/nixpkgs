{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

{
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "116.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "2f67a129ec3bcb47d66cbf29ab23c1c29bfbe752a4703cb0d95f4f3e5a48044901bb79fea94e35f8a9d4dfbfa71aa6721b2988770c1dc33b4412b993bb88da09";
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
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  };

  firefox-beta = buildMozillaMach rec {
    pname = "firefox-beta";
    version = "117.0b5";
    applicationName = "Mozilla Firefox Beta";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "8cb7a96a996b5d3b4e119b4b6317eb7015f9e3d96a3c6a301effe4e5cdaf1c8295a68e57cd919b42a1bef8717ae6764edcbedd4399ca89e14e5f212b144125c1";
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
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox-beta ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-beta-unwrapped";
      versionSuffix = "b[0-9]*";
    };
  };

  firefox-devedition = (buildMozillaMach rec {
    pname = "firefox-devedition";
    version = "117.0b5";
    applicationName = "Mozilla Firefox Developer Edition";
    branding = "browser/branding/aurora";
    src = fetchurl {
      url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "16f2fc0ac5d3cd76659b33b319a39367d5e37d7c2f5246f2f76a57b1455ab16af83872ec4fb74a30e127b744a06d8dc5c99a531d3bf2ff4c6465d1d5e2fcd126";
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
      mainProgram = "firefox";
    };
    tests = [ nixosTests.firefox-devedition ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-devedition-unwrapped";
      versionSuffix = "b[0-9]*";
      baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
    };
  }).overrideAttrs (prev: {
    env.MOZ_REQUIRE_SIGNING = "";
  });

  firefox-esr-102 = buildMozillaMach rec {
    pname = "firefox-esr-102";
    version = "102.14.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "6cabd474d0f3a768a0f12fa5c9984ed193906b503202010fd1da0e2affa091fcc5c165e6b9c4152d286410d46b72b2ddbf52d323bf5ea542f29e5267a94dfdcd";
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
    tests = [ nixosTests.firefox-esr-102 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-102-unwrapped";
      versionPrefix = "102";
      versionSuffix = "esr";
    };
  };

  firefox-esr-115 = buildMozillaMach rec {
    pname = "firefox-esr-115";
    version = "115.1.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "b2abb706fef2f1aa9451e7ac7c2affa0cc92cf2b0c6629f106a94c62017476380c7b6f406861fa468f60ea898d8402f534ad74844eb3932741fbd981cec66592";
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
