{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests, buildMozillaMach }:

{
  firefox = buildMozillaMach rec {
    pname = "firefox";
    version = "115.0.3";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "d42d522e4c2160824c74d94c90b9d61ff7fd0515cddc9e4d544003ddf975fe975aa517493dc28bad31c67915a22477b2fbb42266dc3bda87a2555b7f57a6f5a2";
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
    version = "116.0b8";
    applicationName = "Mozilla Firefox Beta";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "5e34b3eed2ee54de4209af85be80f240c674d22ace072fba5e4cf14a7d733edc0cfd0feafc80b23898ef8c43e5e950b5e683f536d84f12a8a7fcee0120479701";
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

  firefox-devedition = (buildMozillaMach rec {
    pname = "firefox-devedition";
    version = "116.0b8";
    applicationName = "Mozilla Firefox Developer Edition";
    branding = "browser/branding/aurora";
    src = fetchurl {
      url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "06ae0998a537a464a85cf9767555eb1b9d1378345201c9df760cb8ca856fcce61d84ca8398450b80175e9d13e6077df3c5fee9d4781d0879490d30bc6d362a0d";
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
  }).overrideAttrs (prev: {
    env.MOZ_REQUIRE_SIGNING = "";
  });

  firefox-esr-102 = buildMozillaMach rec {
    pname = "firefox-esr-102";
    version = "102.13.0esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "745f4a77e4c898313f11118274d27513f4baa16bb42d5b71d9bd0dbe8957dbf39a5f7ae8442cd711aca9b597bc909c04b44cb8d9094c57aa34e285e64f834fde";
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

  firefox-esr-115 = buildMozillaMach rec {
    pname = "firefox-esr-115";
    version = "115.0.3esr";
    applicationName = "Mozilla Firefox ESR";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "416ee56bd4a602c543391faaa8de31808f267ef2167f7d913195de45d3628de08d0582dbaa8905c847e1431bccd9d1d5d73ad9e7e5ea75be39e4d908a8b40376";
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
    tests = [ nixosTests.firefox-esr-115 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-115-unwrapped";
      versionPrefix = "115";
      versionSuffix = "esr";
    };
  };
}
