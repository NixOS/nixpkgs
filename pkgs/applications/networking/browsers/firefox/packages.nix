{ stdenv, lib, callPackage, fetchurl, fetchpatch }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "83.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "3va5a9471677jfzkhqp8xkba45n0bcpphbabhqbcbnps6p85m3y98pl5jy9q7cpq3a6gxc4ax7bp90yz2nfvfq7i64iz397xpprri2a";
    };

    patches = [
      # Fix compilation on aarch64 with newer rust version
      # See https://bugzilla.mozilla.org/show_bug.cgi?id=1677690
      # and https://bugzilla.redhat.com/show_bug.cgi?id=1897675
      (fetchpatch {
        name = "aarch64-simd-bgz-1677690.patch";
        url = "https://github.com/mozilla/gecko-dev/commit/71597faac0fde4f608a60dd610d0cefac4972cc3.patch";
        sha256 = "1f61nsgbv2c2ylgjs7wdahxrrlgc19gjy5nzs870zr1g832ybwin";
      })
    ];

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
    ffversion = "78.5.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "20h53cn7p4dds1yfm166iwbjdmw4fkv5pfk4z0pni6x8ddjvg19imzs6ggmpnfhaji8mnlknm7xp5j7x9vi24awvdxdds5n88rh25hd";
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
