{ stdenv, lib, buildMozillaMach, callPackage, fetchurl, fetchpatch, nixosTests, icu, fetchpatch2, config }:

let
  common = { version, sha512, updateScript }: (buildMozillaMach rec {
    pname = "thunderbird";
    inherit version updateScript;
    application = "comm/mail";
    applicationName = "Mozilla Thunderbird";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      inherit sha512;
    };
    extraPatches = [
      # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
      ./no-buildconfig.patch
    ];

    meta = with lib; {
      changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
      description = "A full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      mainProgram = "thunderbird";
      maintainers = with maintainers; [ eelco lovesegfault pierron vcunat ];
      platforms = platforms.unix;
      badPlatforms = platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = licenses.mpl20;
    };
  }).override {
    geolocationSupport = false;
    webrtcSupport = false;

    pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

    icu = icu.overrideAttrs (attrs: {
      # standardize vtzone output
      # Work around ICU-22132 https://unicode-org.atlassian.net/browse/ICU-22132
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1790071
      patches = attrs.patches ++ [(fetchpatch2 {
        url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
        stripLen = 3;
        hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
      })];
    });
  };

in rec {
  thunderbird = thunderbird-115;

  thunderbird-115 = common {
    version = "115.12.2";
    sha512 = "182f35e8e5ece98d18dfefe106c73bc97fbc619f59772d9b3455b7c8af412021ecc5eae97a12515224e91deb814abb7a6ef7f538c450e9e77fdfd84078678038";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-115";
      versionPrefix = "115";
    };
  };

  thunderbird-128 = common {
    version = "128.0esr";
    sha512 = "8524fbdcc51eddf83fec439273319315c44e6d3be9e4dcf51e453ced7fd1676abdca44442dcb302c637a98b7873828168f2d2d2b635551e406645a134d09aee0";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-128";
      versionPrefix = "128";
      versionSuffix = "esr";
    };
  };
}
 // lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
}

