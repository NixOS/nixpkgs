{ stdenv, lib, callPackage, fetchurl, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ./common.nix opts) {};

  fetchPGO = { rev, channel, sha512 }: fetchurl {
    curlOpts = [ "--location" "--fail" ];
    url = "https://firefox-ci-tc.services.mozilla.com/api/index/v1/task/gecko.v2.${channel}.revision.${rev}.firefox.linux64-profile/artifacts/public/build/profdata.tar.xz";
    inherit sha512;
    passthru = { inherit rev; };
  };
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "89.0.2";
    rev = "9fcea995d1dabc5a4f4ef3811dc0e6e00d88cbe3";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "ffd98ab0887611c5b4aba68346c49a7a31a58150fd8bbae610a4d941c4cff0acef0daaebfbb577787a759b4c1ef3c1199f02681148612f4f5b709983e07e0ccb";
      passthru = { inherit rev; };
    };
    pgodata = fetchPGO {
      inherit rev;
      channel = "mozilla-release";
      sha512 = "f5da4555cf37ad92e03c72c90b42e3a3d59039ec0785019af335c1573c42a6e7f547e163a1a37244d6214d7e57530a51e557718638d0ed1075a73ea0b6a3f972";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco lovesegfault hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.11.0esr";
    rev = "01d6500ecb254baea73ebad2fb3d29f182046952";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "d02fc2eda587155b1c54ca12a6c5cde220a29f41f154f1c9b71ae8f966d8cc9439201a5b241e03fc0795b74e2479f7aa5d6b69f70b7639432e5382f321f7a6f4";
      passthru = { inherit rev; };
    };
    pgodata = fetchPGO {
      inherit rev;
      channel = "mozilla-esr78";
      sha512 = "fa88abb045de1f9fc8d40376f259eefcf8bb827d5a90fc6777421dedff9037962671a867a4b8779993e2f801343544e2fb0706b21ef0c9ba8ebd910a94057e7b";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-esr ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  };
}
