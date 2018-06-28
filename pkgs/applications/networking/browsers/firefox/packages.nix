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
    version = "61.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0ww2j5gxr7h142lfi0xvckvd7vmnha72j8c0wyyqmmp1rr341f10vfd0hvawiagik4ih6dz8h5pmkl67zdnwqc3z75vwnci20ajlg2s";
    };

    patches = [
      ./env_var_for_system_dir.patch
      ./no-buildconfig.patch
    ];

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

    patches = nixpkgsPatches;

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

        It will clash with firefox binary if you install both. But it
        should not be a problem because you should run browsers in
        separate users/VMs anyway.

        Create new profile by starting it as

        $ firefox -ProfileManager

        and then configure it to use your tor instance.

        Or just use `tor-browser-bundle` package that packs this
        `tor-browser` back into a sanely-built bundle.
      '';
      homepage = https://www.torproject.org/projects/torbrowser.html;
      platforms = lib.platforms.linux;
    };
  };

in rec {

  tor-browser-7-5 = common (rec {
    pname = "tor-browser";
    version = "7.5.5";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.8.1esr-7.5-1-slnos"
      rev   = "08e246847f0ccbee42f61d9449344d461c886cf1";
      sha256 = "023k7427g2hqkpdsw1h384djlyy6jyidpssrrwzbs3qv4s13slah";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser-8-0 = common (rec {
    pname = "tor-browser";
    version = "8.0.1";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.8.0esr-8.0-1-slnos";
      rev   = "5d7e9e1cacbf70840f8f1a9aafe99f354f9ad0ca";
      sha256 = "0cwxwwc4m7331bbp3id694ffwxar0j5kfpgpn9l1z36rmgv92n21";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser = tor-browser-7-5;

})
