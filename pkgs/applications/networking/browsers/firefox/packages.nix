{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "58.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "ff748780492fc66b3e44c7e7641f16206e4c09514224c62d37efac2c59877bdf428a3670bfb50407166d7b505d4e2ea020626fd776b87f6abb6bc5d2e54c773f";
    };

    patches = [
      ./no-buildconfig.patch
      ./env_var_for_system_dir.patch

      # https://bugzilla.mozilla.org/show_bug.cgi?id=1430274
      # Scheduled for firefox 59
      (fetchpatch {
        url = "https://bug1430274.bmoattachments.org/attachment.cgi?id=8943426";
        sha256 = "12yfss3k61yilrb337dh2rffy5hh83d2f16gqrf5i56r9c33f7hf";
      })

      # https://bugzilla.mozilla.org/show_bug.cgi?id=1388981
      # Should have been fixed in firefox 57
    ] ++ lib.optional stdenv.isi686 (fetchpatch {
      url = "https://hg.mozilla.org/mozilla-central/raw-rev/15517c5a5d37";
      sha256 = "1ba487p3hk4w2w7qqfxgv1y57vp86b8g3xhav2j20qd3j3phbbn7";
    });

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
    version = "52.6.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "cf583df34272b7ff8841c3b093ca0819118f9c36d23c6f9b3135db298e84ca022934bcd189add6473922b199b47330c0ecf14c303ab4177c03dbf26e64476fa4";
    };

    patches =
      [ ./env_var_for_system_dir.patch ];

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

    patches =
      [ ./env_var_for_system_dir.patch ];
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

    patches =
      [ ./env_var_for_system_dir.patch ];
  } // commonAttrs) {};

  tor-browser = tor-browser-7-5;

})
