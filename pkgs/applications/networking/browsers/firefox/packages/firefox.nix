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
  version = "155.0.1";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "6d137a7a315cb1d0aac1a3fe314af80fe290c49b7c2e47f8687b25d4720927b2a0dc71a3da9d75f6cab479067db114caa6732d17e888b0abfce99238a8af0f39";
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
