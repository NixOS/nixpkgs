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
  version = "132.0b9";
  applicationName = "Mozilla Firefox Beta";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "0c491e2a601d6989c10cdd757c83453e07454113dac8e4de154df04386fc0797ee5146dcdc8ca904692a6cb87246b54a4f5e93057afd20f23701abd3f61a6985";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
    description = "Web browser built from Firefox Beta Release source tree";
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
    inherit (nixosTests) firefox-beta;
  };
  updateScript = callPackage ./update.nix {
    attrPath = "firefox-beta-unwrapped";
    versionSuffix = "b[0-9]*";
  };
}
