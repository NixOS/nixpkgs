{ lib, callPackage, fetchurl }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "53.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "36ec810bab58e3d99478455a38427a5efbc74d6dd7d4bb93b700fd7429b9b89250efd0abe4609091483991802090c6373c8434dfc9ba64c79a778e51fd2a2886";
    };

    # this patch should no longer be needed in 53
    # from https://bugzilla.mozilla.org/show_bug.cgi?id=1013882
    patches = [ ./fix-debug.patch ];

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
    patches = [ ./fix-debug.patch ];
    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
      versionSuffix = "esr";
    };
  } {};

}
