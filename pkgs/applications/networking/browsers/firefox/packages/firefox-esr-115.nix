{ stdenv, lib, callPackage, fetchurl, nixosTests, buildMozillaMach }:

buildMozillaMach rec {
  pname = "firefox-esr-115";
  version = "115.7.0esr";
  applicationName = "Mozilla Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "d468d8ef117d76e0660c5359c3becf0502354c61bdaaeb4137d86f52b50143abec2ac4578af69afa5670700b57efff1c7323ca23e3339a9eaaa888dee7e8e922";
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
    description = "A web browser built from Firefox Extended Support Release source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
  };
  tests = [ nixosTests.firefox-esr-115 ];
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-esr-115-unwrapped";
    versionPrefix = "115";
    versionSuffix = "esr";
  };
}
