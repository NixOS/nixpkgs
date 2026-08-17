{
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox";
  version = "153.1.0esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "0e5be18878a1bb8575d4ff03b499a092663fcd1779a05b59b82a8b663a3d7047cf3d6f971faeb3d1262f83b23022a703a2033e8ea38bcbd9c85f44bdd35d86c1";
  };

  meta = {
    changelog = "https://www.firefox.com/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
  };
  tests = {
    inherit (nixosTests) firefox-esr-153;
  };
  updateScript = callPackage ../update.nix {
    attrPath = "firefox-esr-153-unwrapped";
    versionPrefix = "153";
    versionSuffix = "esr";
  };
}
