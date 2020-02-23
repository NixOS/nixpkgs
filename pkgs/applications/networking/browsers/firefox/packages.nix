{ config, lib, callPackage, fetchurl }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "73.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "1vdz711v44xdiry5vm4rrg7fjkrlnyn5jjkaq0bcf98jwrn9bjklmgwblrrnvmpc9pjd2ff3m7354q7vy6gd6c3yh2jhbq91v2w5yl9";
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

  firefox-esr-68 = common rec {
    pname = "firefox-esr";
    ffversion = "68.5.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "39i05r7r4rh2jvc8v4m2s2i6d33qaa075a1lc8m9gx7s3rw8yxja2c42cv5hq1imr9zc4dldbk88paz6lv1w8rhncm0dkxw8z6lxkqa";
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
