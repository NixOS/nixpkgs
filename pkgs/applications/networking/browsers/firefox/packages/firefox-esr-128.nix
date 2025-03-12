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
  version = "128.7.0esr";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "26f9661b395b85a44b42bd72ef1ad976c614216c68f6c2dd834d0ac8b84b9c9f398b8ac550a47396995d96e6bb5fa9a50064d7f2f526bddd45aed5039ef131b8";
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
    inherit (nixosTests) firefox-esr-128;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-esr-128-unwrapped";
    versionPrefix = "128";
    versionSuffix = "esr";
  };
}
