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
  version = "143.0b6";
  applicationName = "Firefox Beta";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "d65632e4594b30d38db570ba58b4ee03f87fcdfac010fb153f49b221cfbfd1412c469a8ad6f622075e32340165d6f14b6d962b06e10422c3cf3611d63e4f9b1c";
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
