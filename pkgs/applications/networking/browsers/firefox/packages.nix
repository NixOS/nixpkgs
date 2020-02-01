{ config, lib, callPackage, fetchurl, fetchFromGitHub, overrideCC, gccStdenv, gcc6 }:

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
    ffversion = "72.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "13l23p2dqsf2cpdzaydqqq4kbxlc5jxggz9r2i49avn4q9bqx036zvsq512q1hk37bz2bwq8zdr0530s44zickinls150xq14kq732d";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
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

  firefox-esr-68 = common rec {
    pname = "firefox-esr";
    ffversion = "68.4.2esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "1n7ssx4w5b822bq8zcv6vsy5ph1xjyj9qh6zbnknym5bc0spzk19nrkrpl8a2m26z6xj2lgw1n19gjf4ab6jpfxv3cqq4qwmm0v2fz1";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-68-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  };
} // lib.optionalAttrs (config.allowAliases or true) {
  # ALIASES
  # remove after 20.03 branchoff
  firefox-esr-60 = throw "firefoxPackages.firefox-esr-60 was removed as it's an unsupported ESR with open security issues.";

  icecat = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";
  icecat-52 = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";

  tor-browser-7-5 = throw "firefoxPackages.tor-browser-7-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser-8-5 = throw "firefoxPackages.tor-browser-8-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser = throw "firefoxPackages.tor-browser was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";

}
