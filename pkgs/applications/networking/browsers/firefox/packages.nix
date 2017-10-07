{ lib, callPackage, fetchurl, fetchFromGitHub, hunspell_1_6 }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "56.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "6a07de6bfb71ccdef04b0f2ced720e309d037dd89fe983178ac59ea972147360552e2b8e33d8caa476008cabf53a99003807b0e817150b7a39e0bc143d82b88f";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.linux;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  } {
    enableGTK3 = true;
    hunspell = hunspell_1_6;
  };

  firefox-esr = common rec {
    pname = "firefox-esr";
    version = "52.4.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "be3be7f9dbf4bd0344d5d76f26d1a5090bb012154d25833d5cd58e5e707c080515b42ed751e1f7e58b15b96939d7da634cafb6e8aa9bb1627ff420836b802183";
    };

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
      versionSuffix = "esr";
    };
  } {};

}
