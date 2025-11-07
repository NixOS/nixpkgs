{
  stdenv,
  lib,
  buildMozillaMach,
  callPackage,
  fetchurl,
  icu73,
  icu77,
  fetchpatch2,
  config,
}:

let
  patchICU =
    icu:
    icu.overrideAttrs (attrs: {
      # standardize vtzone output
      # Work around ICU-22132 https://unicode-org.atlassian.net/browse/ICU-22132
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1790071
      patches = attrs.patches ++ [
        (fetchpatch2 {
          url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
          stripLen = 3;
          hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
        })
      ];
    });
  icu73' = patchICU icu73;
  icu77' = patchICU icu77;

  common =
    {
      version,
      sha512,
      updateScript,
      applicationName ? "Thunderbird",
    }:
    (buildMozillaMach rec {
      pname = "thunderbird";
      inherit version updateScript applicationName;
      application = "comm/mail";
      binaryName = "thunderbird";
      src = fetchurl {
        url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
        inherit sha512;
      };
      extraPatches = [
        # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
        (if lib.versionOlder version "140" then ./no-buildconfig.patch else ./no-buildconfig-tb140.patch)
      ];
      extraPassthru = {
        icu73 = icu73';
        icu77 = icu77';
      };

      meta = {
        changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
        description = "Full-featured e-mail client";
        homepage = "https://thunderbird.net/";
        mainProgram = "thunderbird";
        maintainers = with lib.maintainers; [
          booxter # darwin
          lovesegfault
          pierron
          vcunat
        ];
        platforms = lib.platforms.unix;
        broken = stdenv.buildPlatform.is32bit;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = lib.licenses.mpl20;
      };
    }).override
      {
        geolocationSupport = false;
        webrtcSupport = false;

        pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

        icu73 = icu73';
        icu77 = icu77';
      };

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "144.0.1";
    sha512 = "e1859ecd247260c9303a335d14f51d2b80bca7fe0125c41cf6f6bdf1331072dcef490d75fba588b37db5410ce2e7084bbe1c8f568d40c46303891ae2bfbe431c";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-140;

  thunderbird-140 = common {
    applicationName = "Thunderbird ESR";

    version = "140.4.0esr";
    sha512 = "23a7c99f51a346f9df6e0da257040a78da0b9afd70966a0fd5c0f5a4dcd4806520f8d510a382cf5d76a099aa889219a5eec185b774a6a9b65c4ccdcb75662554";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-140";
      versionPrefix = "140";
      versionSuffix = "esr";
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
  thunderbird-115 = throw "Thunderbird 115 support ended in October 2024";
  thunderbird-128 = throw "Thunderbird 128 support ended in August 2025";
}
