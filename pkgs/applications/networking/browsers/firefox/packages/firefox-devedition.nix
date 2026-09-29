{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox-devedition";
  binaryName = "firefox-devedition";
  version = "158.0b1";
  applicationName = "Firefox Developer Edition";
  requireSigning = false;
  branding = "browser/branding/aurora";
  src = fetchurl {
    url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "0780e3f58d8dd3f51863aa5b3abffed59a85ad693f9a15e59de0d7cb926f69aeefa35d68bddcfeb88d148288e7ac5cf03ddb3b33b254db0e781cad07634cac16";
  };

  # buildMozillaMach sets MOZ_APP_REMOTINGNAME during configuration, but
  # unfortunately if the branding file also defines MOZ_APP_REMOTINGNAME, the
  # branding file takes precedence. ("aurora" is the only branding to do this,
  # so far.) We remove it so that the name set in buildMozillaMach takes
  # effect.
  extraPostPatch = ''
    sed -i '/^MOZ_APP_REMOTINGNAME=/d' browser/branding/aurora/configure.sh
  '';

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${lib.versions.majorMinor version}beta/releasenotes/";
    description = "Web browser built from Firefox Developer Edition source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [
      jopejoe1
      rhendric
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = binaryName;
  };
  tests = {
    inherit (nixosTests) firefox-devedition;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-devedition-unwrapped";
    versionSuffix = "b[0-9]*";
    baseUrl = "https://archive.mozilla.org/pub/devedition/releases/";
  };
}
