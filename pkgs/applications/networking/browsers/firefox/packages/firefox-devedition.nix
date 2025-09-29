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
  version = "144.0b6";
  applicationName = "Firefox Developer Edition";
  requireSigning = false;
  branding = "browser/branding/aurora";
  src = fetchurl {
    url = "mirror://mozilla/devedition/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "08a42497eef413f097c4c8191ef2d0e4e7a6f39a63744d51352aaa4016ed8877da4eace81bfc85e97f8e4f17c7ea9225fe11c94e70d6e4c9f4ec69cd43aeecc4";
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
