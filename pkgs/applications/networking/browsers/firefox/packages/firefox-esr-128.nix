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
  version = "128.13.0esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "9e6f3af535e0904219bcac947d458789cc43cbfaf476ac287328323662391eaaadeff57b244599acf3626a2fadc0bc41b70d07e33ca6af4412006ad01ceff034";
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
