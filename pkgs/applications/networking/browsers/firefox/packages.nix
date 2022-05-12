{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

rec {
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "100.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "29c56391c980209ff94c02a9aba18fe27bea188bdcbcf7fe0c0f27f61e823f4507a3ec343b27cb5285cf3901843e9cc4aca8e568beb623c4b69b7282e662b2aa";
    };

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

  firefox-esr-91 = buildMozillaMach rec {
    pname = "firefox-esr";
    version = "91.9.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "fd69d489429052013d2c1b8b766a47920ecee62f0688505758f593b27ae66d6343b9107163749406251aedebdf836147e4d562415a811b04d7ab2ae31e32f133";
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
