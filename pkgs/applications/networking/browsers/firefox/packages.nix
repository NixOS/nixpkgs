{ lib, callPackage, fetchurl, fetchFromGitHub }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "53.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "d56d563db7e1a0faa2de9315b71b479adb9109624d0958224ad2cee331dcbdb4f414380bd91f70ee0b3e543eca812c172eb2d6f6b5620f6dd6f61675f5ac69d8";
    };

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
    version = "52.1.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "ba833904654eda347f83df77e04c8e81572772e8555f187b796ecc30e498b93fb729b6f60935731d9584169adc9d61329155364fddf635cbd11abebe4a600247";
    };

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
      versionSuffix = "esr";
    };
  } {};

  tor-browser = common rec {
    pname = "tor-browser";
    version = "6.5.2";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      rev   = "tor-browser-45.8.0esr-6.5-2";
      sha256 = "0vbcp1qlxjlph0dqibylsyvb8iah3lnzdxc56hllpvbn51vrp39j";
    };

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
  } {
    ffmpegSupport = false;
  };

}
