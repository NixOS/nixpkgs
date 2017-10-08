{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "56.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "6a07de6bfb71ccdef04b0f2ced720e309d037dd89fe983178ac59ea972147360552e2b8e33d8caa476008cabf53a99003807b0e817150b7a39e0bc143d82b88f";
    };

    patches =
      [ ./no-buildconfig.patch ]
      ++ lib.optional stdenv.isi686 (fetchpatch {
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

} // (let

  commonAttrs = {
    overrides = {
      unpackPhase = ''
        # fetchFromGitHub produces ro sources, root dir gets a name that
        # is too long for shebangs. fixing
        cp -a $src .
        mv *-src tor-browser
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

  tor-browser-6-5 = common (rec {
    pname = "tor-browser";
    version = "6.5.2";
    isTorBrowserLike = true;
    extraConfigureFlags = [ "--disable-loop" ];

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      rev   = "tor-browser-45.8.0esr-6.5-2";
      sha256 = "0vbcp1qlxjlph0dqibylsyvb8iah3lnzdxc56hllpvbn51vrp39j";
    };
  } // commonAttrs) {
    stdenv = overrideCC stdenv gcc5;
    ffmpegSupport = false;
  };

  tor-browser-7-0 = common (rec {
    pname = "tor-browser";
    version = "7.0.1";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      rev   = "tor-browser-52.3.0esr-7.0-1-slnos";
      sha256 = "0szbf8gjbl4dnrb4igy4mq5858i1y6ki4skhdw63iqqdd8w9v4yv";
    };
  } // commonAttrs) {};

  tor-browser = tor-browser-7-0;

})
