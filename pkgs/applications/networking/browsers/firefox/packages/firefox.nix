{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox";
  version = "138.0.3";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "0f1c8ee05bec465b55429c18d788856574c5b2e31d911f15f76d31c00de84d8b8681961799c4101cd1540bd228afd201a4b59fd7c9a88918695040965b9dc0f1";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [
      lovesegfault
      hexa
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
  };
  tests = {
    inherit (nixosTests) firefox;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-unwrapped";
  };
}
