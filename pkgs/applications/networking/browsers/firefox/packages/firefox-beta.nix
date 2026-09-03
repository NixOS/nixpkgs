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
  binaryName = "firefox-beta";
  version = "156.0b2";
  applicationName = "Firefox Beta";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "5b685f8b947af0b519c59a308fba6a41f9481df68b7fb6f4b395707653c3ef1822817d2f867d663081cd2d61c8fd4537f46b8002da84b5efa9b8a57ae9491164";
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
