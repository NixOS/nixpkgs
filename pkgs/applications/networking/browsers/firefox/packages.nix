{ lib, callPackage, fetchurl, fetchFromGitHub, overrideCC, gccStdenv, gcc6 }:

let

  common = opts: callPackage (import ./common.nix opts) {};

  # Needed on older branches since rustc: 1.32.0 -> 1.33.0
  missing-documentation-patch = fetchurl {
    name = "missing-documentation.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/deny_missing_docs.patch"
        + "?h=firefox-esr&id=03bdd01f9cf";
    sha256 = "1i33n3fgwc8d0v7j4qn7lbdax0an6swar12gay3q2nwrhg3ic4fb";
  };
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "72.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "37ryimi6yfpcha4c9mcv8gjk38kia1lr5xrj2lglwsr1jai7qxrcd8ljcry8bg87qfwwb9fa13prmn78f5pzpxr7jf8gnsbvr6adxld";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  # Do not remove. This is the last version of Firefox that supports
  # the old plugins. While this package is unsafe to use for browsing
  # the web, there are many old useful plugins targeting offline
  # activities (e.g. ebook readers, syncronous translation, etc) that
  # will probably never be ported to WebExtensions API.
  firefox-esr-52 = (common rec {
    pname = "firefox-esr";
    ffversion = "52.9.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "bfca42668ca78a12a9fb56368f4aae5334b1f7a71966fbba4c32b9c5e6597aac79a6e340ac3966779d2d5563eb47c054ab33cc40bfb7306172138ccbd3adb2b9";
    };

    patches = [
      # this one is actually an omnipresent bug
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
      ./fix-pa-context-connect-retval.patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
      knownVulnerabilities = [ "Support ended in August 2018." ];
    };
  }).override {
    stdenv = overrideCC gccStdenv gcc6; # gcc7 fails with "undefined reference to `__divmoddi4'"
    gtk3Support = false;
  };

  firefox-esr-60 = common rec {
    pname = "firefox-esr";
    ffversion = "60.9.0esr";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "4baea5c9c4eff257834bbaee6d7786f69f7e6bacd24ca13c2705226f4a0d88315ab38c650b2c5e9c76b698f2debc7cea1e5a99cb4dc24e03c48a24df5143a3cf";
    };

    patches = [
      ./no-buildconfig-ffx65.patch

      # this one is actually an omnipresent bug
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
      ./fix-pa-context-connect-retval.patch

      missing-documentation-patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
      knownVulnerabilities = [ "Support ended around October 2019." ];
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-60-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  };

  firefox-esr-68 = common rec {
    pname = "firefox-esr";
    ffversion = "68.4.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "3nqchvyr95c9xvz23z0kcqqyx8lskw0lxa3rahiagc7b71pnrk8l40c7327q1wd4y5g16lix0fg04xiy6lqjfycjsrjlfr2y6b51n4d";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-68-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  };

} // (let

  iccommon = args: common (args // {
    pname = "icecat";
    isIceCatLike = true;

    meta = (args.meta or {}) // {
      description = "The GNU version of the Firefox web browser";
      longDescription = ''
        GNUzilla is the GNU version of the Mozilla suite, and GNU
        IceCat is the GNU version of the Firefox web browser.

        Notable differences from mainline Firefox:

        - entirely free software, no non-free plugins, addons,
          artwork,
        - no telemetry, no "studies",
        - sane privacy and security defaults (for instance, unlike
          Firefox, IceCat does _zero_ network requests on startup by
          default, which means that with IceCat you won't need to
          unplug your Ethernet cable each time you want to create a
          new browser profile without announcing that action to a
          bunch of data-hungry corporations),
        - all essential privacy and security settings can be
          configured directly from the main screen,
        - optional first party isolation (like TorBrowser),
        - comes with HTTPS Everywhere (like TorBrowser), Tor Browser
          Button (like TorBrowser Bundle), LibreJS, and SpyBlock
          plugins out of the box.

        This package can be installed together with Firefox and
        TorBrowser, it will use distinct binary names and profile
        directories.
      '';
      homepage = "https://www.gnu.org/software/gnuzilla/";
      platforms = lib.platforms.unix;
      license = with lib.licenses; [ mpl20 gpl3Plus ];
    };
  });

in {

  icecat = iccommon rec {
    ffversion = "60.3.0";
    icversion = "${ffversion}-gnu1";

    src = fetchurl {
      url = "mirror://gnu/gnuzilla/${ffversion}/icecat-${icversion}.tar.bz2";
      sha256 = "0icnl64nxcyf7dprpdpygxhabsvyhps8c3ixysj9bcdlj9q34ib1";
    };

    patches = [
      ./no-buildconfig.patch
      missing-documentation-patch
    ];
    meta.knownVulnerabilities = [ "Support ended around October 2019." ];
  };

  # Similarly to firefox-esr-52 above.
  icecat-52 = iccommon rec {
    ffversion = "52.6.0";
    icversion = "${ffversion}-gnu1";

    src = fetchurl {
      url = "mirror://gnu/gnuzilla/${ffversion}/icecat-${icversion}.tar.bz2";
      sha256 = "09fn54glqg1aa93hnz5zdcy07cps09dbni2b4200azh6nang630a";
    };

    patches = [
      # this one is actually an omnipresent bug
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
      ./fix-pa-context-connect-retval.patch
    ];

    meta.knownVulnerabilities = [ "Support ended in August 2018." ];
  };

  tor-browser-7-5 = throw "firefoxPackages.tor-browser-7-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser-8-5 = throw "firefoxPackages.tor-browser-8-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser = throw "firefoxPackages.tor-browser was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";

})
