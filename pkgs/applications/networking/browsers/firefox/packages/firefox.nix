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
  version = "136.0.1";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "e5833ccf97796c15b5156357427621d1f2d1d7ee55b53262f3935eadb98229c74a355bbe2f72a4168ec4e29dd3f83f4eaca99c5215d61bd087475331d3522abd";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [
      lovesegfault
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
