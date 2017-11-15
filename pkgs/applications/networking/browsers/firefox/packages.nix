{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "57.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "bd99ff97a2a6f824e6fbd36fd00193903159e309506b1e6945dcbc43a17a95aaa54a05f32131c56872e8860878ba6063008667955550f03aa8c7084f834d14fc";
    };

    patches =
      [ ./no-buildconfig.patch ./env_var_for_system_dir.patch ]
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
    version = "52.5.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "fe724108ba538e590b87a5c1b817471d3cca9b038ba2755642e4d7b8ebb6174322be1fe074f24ef181946f9a027106b50b500d2fa541d8a99ef44905822eda18";
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

  tor-browser-6-5 = common (rec {
    pname = "tor-browser";
    version = "6.5.2";
    isTorBrowserLike = true;
    extraConfigureFlags = [ "--disable-loop" ];

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo = "tor-browser";
      # branch "tor-browser-45.8.0esr-6.5-2"
      rev = "e4140ea01b9906934f0347e95f860cec207ea824";
      sha256 = "0a1qk3a9a3xxrl56bp4zbknbchv5x17k1w5kgcf4j3vklcv6av60";
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

    patches =
      [ ./env_var_for_system_dir.patch ];
  } // commonAttrs) {};

  tor-browser = tor-browser-7-0;

})
