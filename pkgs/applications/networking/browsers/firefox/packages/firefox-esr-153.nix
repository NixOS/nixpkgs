{
  lib,
  callPackage,
  fetchurl,
  nixosTests,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox";
  version = "153.6.0esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "3e9f1f8e7c14d1994f4896702a50b46c1a3c7c7b696a080112f5ab3fdf0fcdd41ade4e81f9abafe2d3824cf1dfb16b5c09e5eaec12a05a733906f1483395565d";
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
