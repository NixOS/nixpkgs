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
  version = "128.5.0esr";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "ff20f18f92c5e9cd1d9eaf7c38cec61bcab2dca8dd2817519b712bc1f760b5c6e290212acf3289152764e5130e01626950b7ecd9327b2c587b24a246591afd67";
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
