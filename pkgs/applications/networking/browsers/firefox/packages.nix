{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    version = "97.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "efbf33723f5979025454b6cc183927afb4bc72a51c00b5d45940122da596b8ac99080f3a6a59f5dd85a725e356349ec57e7eba1c36cdab7d55a28b04895d274c";
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
    version = "91.7.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "c56aa38e9d706ff1f1838d2639dac82109dcffb54a7ea17326ae306604d78967ac32da13676756999bc1aa0bf50dc4e7072936ceb16e2e834bea48382ae4b48c";
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
  };
}
