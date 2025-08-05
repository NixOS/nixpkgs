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
  version = "140.1.0esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "1b5caff9b381cd449c40d148542501f7a31a7151a3f2f888e789c9743af8ee1d1eddbd970f8c0054902d1e1d739221db0cfcf1dc6ab704bb83bbb7b7b6a20055";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
  };
  tests = {
    inherit (nixosTests) firefox-esr-140;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-esr-140-unwrapped";
    versionPrefix = "140";
    versionSuffix = "esr";
  };
}
