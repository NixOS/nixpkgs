{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox-beta";
  binaryName = pname;
  version = "143.0b8";
  applicationName = "Firefox Beta";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "bf8e78abcc1cf6c8b48a591d0185c85195a818de0d13bafa3f004ad9c76364a2c07cacdf09fe0ae2e290d9cbce7b8c3ba4b57793cd3d39240023ef53eea08377";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
    description = "Web browser built from Firefox Beta Release source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = binaryName;
  };
  tests = {
    inherit (nixosTests) firefox-beta;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-beta-unwrapped";
    versionSuffix = "b[0-9]*";
  };
}
