{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "56.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "35f81e8163a254b7e134fc073acbcff63aa1025b9c6392377650a8f2d0a5f0c77211adb0ae3d8ac85f036bb387246934b8847f14a03fceb7fcbc5b3cf94c9392";
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
    version = "52.4.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "d80c7219548391d8a47b6e404662ea41e6acfa264a67d69365e76dd8943077e388ab24b030850919f8fc6681c11486bdbaaf170d441c861f4a12cedbe08955ab";
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
    gssSupport = false;
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
