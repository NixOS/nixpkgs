{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox-devedition";
  binaryName = pname;
  version = "140.0b4";
  applicationName = "Firefox Developer Edition";
  requireSigning = false;
  branding = "browser/branding/aurora";
  src = fetchurl {
    url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "bc71e5183b7f527f006b82ba729cb9556a0c756059025392d31ace1e3e49c0a48f5f7c8b64615353c7ae72ab67eb77212f3b573ea06a278f806328093d1424a4";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
    description = "Web browser built from Firefox Developer Edition source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [
      jopejoe1
      rhendric
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = binaryName;
  };
  tests = {
    inherit (nixosTests) firefox-devedition;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-devedition-unwrapped";
    versionSuffix = "b[0-9]*";
    baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
  };
}
