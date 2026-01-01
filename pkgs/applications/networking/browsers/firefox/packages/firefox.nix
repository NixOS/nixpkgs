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
<<<<<<< HEAD
  version = "146.0.1";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "ae95b86e483febf8dfec8347748dd9048ed7d7f845250e07aa8048e2b351da61f6f3c5f83bb0d0c72e1a75ec61b60e59bbe69639f0f33532910ff8bf5ca07394";
=======
  version = "145.0.2";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "99d28daf7054c80bc521c8b73d1cf5c1beb77ac9b66904fdbb5890f89ddf5b12a2715deaf867ed86a4806cf4f44952f7bcceb38cc5f2faf9290b0a07be823418";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
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
