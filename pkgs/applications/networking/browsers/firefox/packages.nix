{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach
, python311
}:

{
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "131.0.3";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "3aa96db839f7a45e34c43b5e7e3333e1100ca11545ad26a8e42987fbc72df5ae7ebebe7dfc8c4e856d2bb4676c0516914a07c001f6047799f314146a3329c0ce";
    };

    extraPatches = [
    ];

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
      description = "Web browser built from Firefox source tree";
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
    tests = { inherit (nixosTests) firefox; };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  };

  firefox-beta = buildMozillaMach rec {
    pname = "firefox-beta";
    version = "132.0b9";
    applicationName = "Mozilla Firefox Beta";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0c491e2a601d6989c10cdd757c83453e07454113dac8e4de154df04386fc0797ee5146dcdc8ca904692a6cb87246b54a4f5e93057afd20f23701abd3f61a6985";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
      description = "Web browser built from Firefox Beta Release source tree";
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
    tests = { inherit (nixosTests) firefox-beta; };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-beta-unwrapped";
      versionSuffix = "b[0-9]*";
    };
  };

  firefox-devedition = buildMozillaMach rec {
    pname = "firefox-devedition";
    version = "132.0b9";
    applicationName = "Mozilla Firefox Developer Edition";
    requireSigning = false;
    branding = "browser/branding/aurora";
    src = fetchurl {
      url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "3393bb677c6e735860ef49c837ffab10720c6eb47d6cfb6c7960267e3676c69c8293b5f7e49de3f91b6eb88fa4780300db2b2653dde1ae38d546f473bca7e34b";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
      description = "Web browser built from Firefox Developer Edition source tree";
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
    tests = { inherit (nixosTests) firefox-devedition; };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-devedition-unwrapped";
      versionSuffix = "b[0-9]*";
      baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
    };
  };

  firefox-esr-128 = buildMozillaMach rec {
    pname = "firefox";
    version = "128.3.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "c5c1a2e951e0dbb1259a0f77a26b8678bfa4a4c7e909f8fcd5c6d0f807625926824ed235e114d9bab5e289232efaaf4c6691764db64860161ebc9bece9200f0c";
    };

    meta = {
      changelog = "https://www.mozilla.org/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
      description = "Web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
      mainProgram = "firefox";
    };
    tests = { inherit (nixosTests) firefox-esr-128; };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-128-unwrapped";
      versionPrefix = "128";
      versionSuffix = "esr";
    };
  };
}
