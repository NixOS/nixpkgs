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
  version = "131.0.3";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "3aa96db839f7a45e34c43b5e7e3333e1100ca11545ad26a8e42987fbc72df5ae7ebebe7dfc8c4e856d2bb4676c0516914a07c001f6047799f314146a3329c0ce";
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
    badPlatforms = lib.platforms.darwin;
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
  updateScript = callPackage ./update.nix {
    attrPath = "firefox-unwrapped";
  };
}
