{ lib, callPackage, stdenv, fetchurl, fetchFromGitHub, fetchpatch, python3, overrideCC, gccStdenv, gcc6 }:

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
    ffversion = "66.0.5";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "18bcpbwzhc2fi6cqhxhh6jiw5akhzr7qqs6s8irjbvh7q8f3z2n046vrlvpblhbkc2kv1n0s14n49yzv432adqwa9qi8d57jnxyfqkf";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    extraNativeBuildInputs = [ python3 ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
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
    ffversion = "60.6.3esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "3zg75djd7mbr9alhkp7zqrky7g41apyf6ka0acv500dmpnhvn5v5i0wy9ks8v6vh7kcgw7bngf6msb7vbbps6whwdcqv3v4dqbg6yr2";
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
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-60-unwrapped";
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

in rec {

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

}) // (let

  tbcommon = args: common (args // {
    pname = "tor-browser";
    isTorBrowserLike = true;

    unpackPhase = ''
      # fetchFromGitHub produces ro sources, root dir gets a name that
      # is too long for shebangs. fixing
      cp -a $src tor-browser
      chmod -R +w tor-browser
      cd tor-browser

      # set times for xpi archives
      find . -exec touch -d'2010-01-01 00:00' {} \;
    '';

    meta = (args.meta or {}) // {
      description = "A web browser built from TorBrowser source tree";
      longDescription = ''
        This is a version of TorBrowser with bundle-related patches
        reverted.

        I.e. it's a variant of Firefox with less fingerprinting and
        some isolation features you can't get with any extensions.

        Or, alternatively, a variant of TorBrowser that works like any
        other UNIX program and doesn't expect you to run it from a
        bundle.

        It will use your default Firefox profile if you're not careful
        even! Be careful!

        It will clash with firefox binary if you install both. But it
        should not be a problem because you should run browsers in
        separate users/VMs anyway.

        Create new profile by starting it as

        $ firefox -ProfileManager

        and then configure it to use your tor instance.

        Or just use `tor-browser-bundle` package that packs this
        `tor-browser` back into a sanely-built bundle.
      '';
      homepage = "https://www.torproject.org/projects/torbrowser.html";
      platforms = lib.platforms.unix;
      license = with lib.licenses; [ mpl20 bsd3 ];
    };
  });

in rec {

  tor-browser-7-5 = (tbcommon rec {
    ffversion = "52.9.0esr";
    tbversion = "7.5.6";

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.9.0esr-7.5-2-slnos"
      rev   = "95bb92d552876a1f4260edf68fda5faa3eb36ad8";
      sha256 = "1ykn3yg4s36g2cpzxbz7s995c33ij8kgyvghx38z4i8siaqxdddy";
    };
  }).override {
    gtk3Support = false;
  };

  tor-browser-8-0 = tbcommon rec {
    ffversion = "60.6.1esr";
    tbversion = "8.0.9";

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-60.6.1esr-8.0-1-r2-slnos"
      rev   = "d311540ce07f1f4f5e5789f9107f6e6ecc23988d";
      sha256 = "0nz8vxv53vnqyk3ahakrr5xg6sgapvlmsb6s1pwwsb86fxk6pm5f";
    };

    patches = [
      missing-documentation-patch
    ];
  };

  tor-browser = tor-browser-8-0;

})
