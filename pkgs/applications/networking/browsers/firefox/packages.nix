{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    version = "99.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0006b773ef1057a6e0b959d4f39849ad4a79272b38d565da98062b9aaf0effd2b729349c1f9fa10fccf7d2462d2c536b02c167ae6ad4556d6e519c6d22c25a7f";
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

  firefox-esr-91 = common rec {
    pname = "firefox-esr";
    version = "91.8.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "edea2c7d4d3d0322091b20b623019ef041090d9f89f33c8e3140f66a54624261f278257393db70d2038154de8ee02da0bee6ecf85c281f3558338da71fc173c3";
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

  librewolf =
  let
    librewolf-src = callPackage ./librewolf { };
  in
  (common rec {
    pname = "librewolf";
    binaryName = "librewolf";
    version = librewolf-src.packageVersion;
    src = librewolf-src.firefox;
    inherit (librewolf-src) extraConfigureFlags extraPostPatch extraPassthru;

    meta = {
      description = "A fork of Firefox, focused on privacy, security and freedom";
      homepage = "https://librewolf.net/";
      maintainers = with lib.maintainers; [ squalus ];
      inherit (firefox.meta) platforms badPlatforms broken maxSilent license;
    };
    updateScript = callPackage ./librewolf/update.nix {
      attrPath = "librewolf-unwrapped";
    };
  }).override {
    crashreporterSupport = false;
    enableOfficialBranding = false;
    pgoSupport = false; # Profiling gets stuck and doesn't terminate.
  };
}
