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
  version = "140.0b2";
  applicationName = "Mozilla Firefox Developer Edition";
  requireSigning = false;
  branding = "browser/branding/aurora";
  src = fetchurl {
    url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "4a369638dab1202f21f071a1eb48552888adf01e49ee4e029dfe7b42919312719004099b203a066057fd4d9ef9a684e5f95b0aa06ecf82cc88df0025f33f6368";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
    description = "Web browser built from Firefox Developer Edition source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ jopejoe1 ];
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
    inherit (nixosTests) firefox-devedition;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-devedition-unwrapped";
    versionSuffix = "b[0-9]*";
    baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
  };
}
