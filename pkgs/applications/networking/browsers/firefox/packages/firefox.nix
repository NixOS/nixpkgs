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
  version = "152.0.5";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "6cf2dc7f28a6a3430f2866df4ca35063cbadf234c82a34fa651e02d909e5741e50cd986fef1bd97d486b51244cb639b2b103514688347bf7f94fd16d264cc4f2";
  };

  meta = {
    changelog = "https://www.firefox.com/en-US/firefox/${version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [
      booxter # darwin
      hexa
    ];
    platforms = lib.platforms.unix;
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
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-unwrapped";
  };
}
