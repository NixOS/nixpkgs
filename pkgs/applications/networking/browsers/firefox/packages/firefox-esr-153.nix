{
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox";
  version = "153.5.1esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "9dccf8c5383653ddcf807b500889a91f9b9d56a512dab88a2683755ae6cb0c4b5d0788faa9541e5709a2b783002ee9f434020a43c8a43653038a2c3decd9f2c1";
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
    identifiers = {
      cpeParts = {
        product = "firefox";
        sw_edition = "esr";
        update = "*";
        vendor = "mozilla";
        version = lib.removeSuffix "esr" version;
      };
      purlParts = {
        type = "generic";
        spec = "firefox@${lib.removeSuffix "esr" version}";
      };
    };
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
