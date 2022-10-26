{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

rec {
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "106.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "2aad75c05c3398c19842be46dcde275581344b09f0c65b51a630cef201545996ee00f8020f52a0d7b6416d9ad52cbd5c71b8f1cdf47cd18e4abf1ba21f7cdb93";
    };

    # This patch could be applied anywhere (just rebuild, no effect)
    extraPatches = lib.optionals stdenv.isAarch64 [
      (fetchpatch { # https://bugzilla.mozilla.org/show_bug.cgi?id=1791275
        name = "no-sysctl-aarch64.patch";
        url = "https://hg.mozilla.org/mozilla-central/raw-rev/0efaf5a00aaceeed679885e4cd393bd9a5fcd0ff";
        hash = "sha256-wS/KufeLFxCexQalGGNg8+vnQhzDiL79OLt8FtL/JJ8=";
      })
    ];

    meta = {
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
    pname = "firefox-esr";
    version = "102.4.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "30d9e6ef04fd86516e2cea3c797ec99af4c96b08576bb3409c0026da4fd1218167f89a007109e1fa4e2571f98f2dbe5ab58a26473533d45301f75b90ec3dbf28";
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
    tests = [ nixosTests.firefox-esr-102 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-102-unwrapped";
      versionSuffix = "esr";
    };
  };

  firefox-esr-91 = buildMozillaMach rec {
    pname = "firefox-esr";
    version = "91.13.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "38b4cc52de21e76d6061e6ba175e1cbfd888a16070aa951f5a44283f2db9d7e94f2504621f0da78feac6e71491a6d0e7038f63dd0ae112dcad700eb02e9aa516";
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
      knownVulnerabilities = [
        "Firefox 91.13.0esr was the last release in the 91esr series, which has reached the end of its life. Migrate to the 102esr series instead."
      ];
    };
    tests = [ nixosTests.firefox-esr-91 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-91-unwrapped";
      versionSuffix = "esr";
    };
  };
}
