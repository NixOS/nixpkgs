{ lib, callPackage, fetchurl, fetchFromGitHub, hunspell_1_6 }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "54.0.1";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "43607c2c0af995a21dc7f0f68b24b7e5bdb3faa5ee06025901c826bfe4d169256ea1c9eb5fcc604c4d6426ced53e80787c12fc07cda014eca09199ef3df783a2";
    };

    patches = [ ./cargo-fix.patch ];

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
    version = "52.2.1esr";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "1d79e6e4625cf7994f6d6bbdf227e483fc407bcdb20e0296ea604969e701f551b5df32f578d4669cf654b65927328c8eb0f717c7a12399bf1b02a6ac7a0cd1d3";
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
