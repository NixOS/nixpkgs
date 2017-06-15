{ lib, callPackage, fetchurl, fetchFromGitHub, hunspell_1_6 }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "54.0";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0ff6960804e7f6d3e15faeb14b237fee45acae31b4652a6cc5cafa1a1b1eab3537616c3e8ea6d8f3109c87dcc8f86f0df3da2627903b80061c8a62fb11598ed9";
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
    version = "52.2.0esr";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "62a2bd47c9f4b325199b8a0b155a7a412ffbd493e8ca6ff246ade5b10aacea22bc806bc646824059f7c97b71d27e167025c600293c781fbad3fdefb8bbc8d18e";
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
