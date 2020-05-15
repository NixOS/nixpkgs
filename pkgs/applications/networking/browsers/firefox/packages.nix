{ config, stdenv, lib, callPackage, fetchurl }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "76.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "0gnhfcgrz6022xf3vqia3s3639xa5pjp13h343d3c09mn8r919cmm6s38vzj1v3734fm25zb68acyarsp72xqq8z1420rh02b2pv38q";
    };

    patches = [
      ./no-buildconfig-ffx76.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-68 = common rec {
    pname = "firefox-esr";
    ffversion = "68.8.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "2rl5irkamxi8caa8krj0wng93lb82kk9mf09mgci87mj9hy6fxzcrlmiiffp14s03rv0raagrn4w54pbx1336mylq6saxmfhpf676hk";
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
  #### ALIASES
  #### remove after 20.03 branchoff

  firefox-esr-52 = throw ''
    firefoxPackages.firefox-esr-52 was removed as it's an unsupported ESR with
    open security issues. If you need it because you need to run some plugins
    not having been ported to WebExtensions API, import it from an older
    nixpkgs checkout still containing it.
  '';
  firefox-esr-60 = throw "firefoxPackages.firefox-esr-60 was removed as it's an unsupported ESR with open security issues.";

  icecat = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";
  icecat-52 = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";

  tor-browser-7-5 = throw "firefoxPackages.tor-browser-7-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser-8-5 = throw "firefoxPackages.tor-browser-8-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser = throw "firefoxPackages.tor-browser was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";

}
