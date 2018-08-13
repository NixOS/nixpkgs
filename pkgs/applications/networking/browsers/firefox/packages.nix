{ lib, callPackage, stdenv, fetchurl, fetchFromGitHub, fetchpatch, python3 }:

let

  common = opts: callPackage (import ./common.nix opts);

  nixpkgsPatches = [
    ./env_var_for_system_dir.patch
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
    version = "61.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "3zzcxqjpsn2m5z4l66rxrq7yf58aii370jj8pcl50smcd55sfsyknnc20agbppsw4k4pnwycfn57im33swwkjzg0hk0h2ng4rvi42x2";
    };

    patches = nixpkgsPatches ++ [
      ./no-buildconfig.patch
    ];

    extraNativeBuildInputs = [ python3 ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.unix;
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  } {};

  firefox-esr-52 = common rec {
    pname = "firefox-esr";
    version = "52.9.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "bfca42668ca78a12a9fb56368f4aae5334b1f7a71966fbba4c32b9c5e6597aac79a6e340ac3966779d2d5563eb47c054ab33cc40bfb7306172138ccbd3adb2b9";
    };

    patches = nixpkgsPatches ++ [
      # this one is actually an omnipresent bug
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
      ./fix-pa-context-connect-retval.patch
    ];

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
    version = "60.1.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "2bg7zvkpy1x2ryiazvk4nn5m94v0addbhrcrlcf9djnqjf14rp5q50lbiymhxxz0988vgpicsvizifb8gb3hi7b8g17rdw6438ddhh6";
    };

    patches = nixpkgsPatches ++ [
      ./no-buildconfig.patch

      # this one is actually an omnipresent bug
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
      ./fix-pa-context-connect-retval.patch
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
      license = lib.licenses.bsd3;
    };
  };

in rec {

  tor-browser-7-5 = common (rec {
    pname = "tor-browser";
    version = "7.5.6";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.9.0esr-7.5-2-slnos"
      rev   = "95bb92d552876a1f4260edf68fda5faa3eb36ad8";
      sha256 = "1ykn3yg4s36g2cpzxbz7s995c33ij8kgyvghx38z4i8siaqxdddy";
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
