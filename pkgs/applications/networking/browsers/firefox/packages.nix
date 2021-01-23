{ stdenv, lib, callPackage, fetchurl, fetchpatch }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "84.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "2cxybnrcr0n75hnw18rrymw1jsd5crqfgnpk10hywbmnkdc72fx5sk51cg890pzwfiagicxfxsacnm3f6g8135k0wsz4294xjjwkm1z";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
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

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.6.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "3kq9vb0a8qblqk995xqhghw5d694mr1cjd5alkkwxbdjhpc1mck0ayn40xjph0znga6qdcq8l366p0by8ifbsdhv0x39ng8nvx9jvdf";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionKey = "ffversion";
    };
  };
}
