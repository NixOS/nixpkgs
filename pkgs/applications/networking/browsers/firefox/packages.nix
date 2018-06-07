{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let

  common = opts: callPackage (import ./common.nix opts);

  nixpkgsPatches = [
    ./env_var_for_system_dir.patch

    # this one is actually an omnipresent bug
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
    ./fix-pa-context-connect-retval.patch
  ];

  firefox60_aarch64_skia_patch = fetchpatch {
      name = "aarch64-skia.patch";
      url = https://src.fedoraproject.org/rpms/firefox/raw/8cff86d95da3190272d1beddd45b41de3148f8ef/f/build-aarch64-skia.patch;
      sha256 = "11acb0ms4jrswp7268nm2p8g8l4lv8zc666a5bqjbb09x9k6b78k";
  };

in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "60.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "2my4v8al3swwbiqcp3a5y89imly6apc2p9q0cbkhbiz0sqylc0l02jh0qp95migmik56m4prwqdi81kgqs7cw5r2np3mm6sc1b45mkg";
    };

    patches = nixpkgsPatches ++ [
      ./no-buildconfig.patch
    ] ++ lib.optional stdenv.isAarch64 firefox60_aarch64_skia_patch;

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.linux;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  } {};

  firefox-esr-52 = common rec {
    pname = "firefox-esr";
    version = "52.8.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "a4883550fdf62e66b10f1de7416d3614a2cb0ce3a004d9a79ecc37a726794d7bbdb0a6767faab4ea97278d2192462597551fc13b7e9a9c38d043c2879d51095a";
    };

    patches = nixpkgsPatches
    # The following patch is only required on ARM platforms and should be
    # included for the next ESR release >= 52.7.3esr
    ++ lib.optional stdenv.isAarch32
      (fetchpatch {
        name = "CVE-2018-5147-tremor.patch";
        url = https://hg.mozilla.org/releases/mozilla-esr52/rev/5cd5586a2f48;
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
      })
    ;

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-52-unwrapped";
      versionSuffix = "esr";
    };
  } {};

  firefox-esr-60 = common rec {
    pname = "firefox-esr";
    version = "60.0.2esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0vbilh4iwqfzkj598zbgkmwbkxh4bia8gn7p9x6xd7yvhb6708p4dfkkbg61hdh3bddyaxx1zd0wi8qxfxbrx19mc6k9dpc6xz52iy1";
    };

    patches = nixpkgsPatches ++ [
      ./no-buildconfig.patch
    ] ++ lib.optional stdenv.isAarch64 firefox60_aarch64_skia_patch;

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-60-unwrapped";
      versionSuffix = "esr";
    };
  } {};

} // (let

  commonAttrs = {
    overrides = {
      unpackPhase = ''
        # fetchFromGitHub produces ro sources, root dir gets a name that
        # is too long for shebangs. fixing
        cp -a $src tor-browser
        chmod -R +w tor-browser
        cd tor-browser

        # set times for xpi archives
        find . -exec touch -d'2010-01-01 00:00' {} \;
      '';
    };

    meta = {
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

        It will clash with firefox binary if you install both. But its
        not a problem since you should run browsers in separate
        users/VMs anyway.

        Create new profile by starting it as

        $ firefox -ProfileManager

        and then configure it to use your tor instance.
      '';
      homepage = https://www.torproject.org/projects/torbrowser.html;
      platforms = lib.platforms.linux;
    };
  };

in rec {

  tor-browser-7-0 = common (rec {
    pname = "tor-browser";
    version = "7.0.1";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.5.0esr-7.0-1-slnos";
      rev   = "830ff8d622ef20345d83f386174f790b0fc2440d";
      sha256 = "169mjkr0bp80yv9nzza7kay7y2k03lpnx71h4ybcv9ygxgzdgax5";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser-7-5 = common (rec {
    pname = "tor-browser";
    version = "7.5.2";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.6.2esr-7.5-2-slnos";
      rev   = "cf1a504aaa26af962ae909a3811c0038db2d2eec";
      sha256 = "0llbk7skh1n7yj137gv7rnxfasxsnvfjp4ss7h1fbdnw19yba115";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser = tor-browser-7-5;

})
