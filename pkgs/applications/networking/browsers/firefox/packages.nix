{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let

  common = opts: callPackage (import ./common.nix opts);

  nixpkgsPatches = [
    ./env_var_for_system_dir.patch

    # this one is actually an omnipresent bug
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
    ./fix-pa-context-connect-retval.patch
  ];

in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "59.0";
    src = fetchurl {
      url = "https://hg.mozilla.org/releases/mozilla-release/archive/c61f5f5ead48c78a80c80db5c489bdc7cfaf8175.tar.bz2";
      sha512 = "03yybi1yp9g29jzdfgrq32r7a0gl2jz64w6ai8219cvhx8y95ahxfznj3vm29frrp6c18dk2nlpv2s89iczwm00lnn42r7dn6s6ppl9";
    };

    patches = nixpkgsPatches ++ [
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

  firefox-esr = common rec {
    pname = "firefox-esr";
    version = "52.7.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "0275ca9c093fd0dcf09cfd31a4bca8c6ddb87aa74ace6b273a62f61079eeed11c2c0330c52c5f76aa73ed97e9cd18aa63cee69387e1fe346a30e4f9affc91ba7";
    };

    patches = nixpkgsPatches;

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
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
      # branch "tor-browser-52.7.0esr-7.5-1-slnos";
      rev   = "211b2be3fea45a450915b0addcd7783aa939e24a";
      sha256 = "18gv4r8cjf89mamjh93a856a5yfp7dm3jrk8g05w89vxb3lrl74v";
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
      # branch "tor-browser-52.7.0esr-8.0-1-slnos";
      rev   = "58314ccb043882e830ee9a21c37a92d6e0d34e94";
      sha256 = "09gb7chw2kly53b599xwpi75azj00957rnxly9fqv8zi3n5k2pdb";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser = tor-browser-7-5;

})
