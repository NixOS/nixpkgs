{ stdenv, lib, callPackage, fetchurl, nixosTests, buildMozillaMach }:

buildMozillaMach rec {
  pname = "firefox";
  version = "122.0.1";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "1d4fe1ed351edd748ede2ef6448798a32de9ed7a075a54a7ed5f7baa7b0c4c7f932c2e29f443c9066829e39f22a1dc94be5d00cc994193e949b72aa4a1c8ba41";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "A web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ lovesegfault hexa ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
  };
  tests = [ nixosTests.firefox ];
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-unwrapped";
  };
}
