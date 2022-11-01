{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

rec {
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "106.0.3";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "226bde9082330abe134d1726cec59b473d4d6839ea55ca20faddb901f032d89eb9d2bd5d887ccd4ba515c6b1a44817420cfee2e9f4f8a79ed46a38287083d28d";
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
    pname = "firefox-esr-102";
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
      versionPrefix = "102";
      versionSuffix = "esr";
    };
  };
}
