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
  version = "157.0";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "d0c1788102904fe83bfbeecdbdfbd4033743e9bb791ff7063ca4a2a72146c722e0c87fb7531b32be9491f5b1529960364197150c27742e0aea3cefcd13ed0dde";
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
    identifiers = {
      cpeParts = {
        inherit version;
        product = "firefox";
        update = "*";
        vendor = "mozilla";
      };
      purlParts = {
        type = "generic";
        spec = "firefox@${version}";
      };
    };
  };
  tests = {
    inherit (nixosTests) firefox;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-unwrapped";
  };
}
