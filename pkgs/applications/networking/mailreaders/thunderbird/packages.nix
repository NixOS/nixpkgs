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
      ]
      ++ lib.optional (lib.versionAtLeast version "140") (fetchpatch2 {
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1982003
        name = "rustc-1.89.patch";
        url = "https://raw.githubusercontent.com/openbsd/ports/3ef8a2538893109bea8211ef13a870822264e096/mail/mozilla-thunderbird/patches/patch-third_party_rust_allocator-api2_src_stable_vec_mod_rs";
        extraPrefix = "";
        hash = "sha256-eL+RNVLMkj8x/8qQJVUFHDdDpS0ahV1XEN1L0reaYG4=";
      })
      ++ lib.optionals (lib.versionOlder version "139") [
        # clang-19 fixes for char_traits build issue
        # https://github.com/rnpgp/rnp/pull/2242/commits/e0790a2c4ff8e09d52522785cec1c9db23d304ac
        # https://github.com/rnpgp/sexpp/pull/54/commits/46744a14ffc235330bb99cebfaf294829c31bba4
        # Remove when upstream bumps bundled rnp version: https://bugzilla.mozilla.org/show_bug.cgi?id=1893950
        ./0001-Removed-lookup-against-basic_string-uint8_t.patch
        ./0001-Implemented-char_traits-for-SEXP-octet_t.patch
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
    version = "143.0.1";
    sha512 = "5f4fd5e4f5bc9fee9852d51b8e675f7c9c605660332c24aa0c90e5437301b468153c1788720bc80a53cfc1c3bf95a4bdb622a0533b8f11fb9853b290485c47c6";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-140;

  thunderbird-140 = common {
    applicationName = "Thunderbird ESR";

    version = "140.3.0esr";
    sha512 = "82a9c4aa250b01e0e4d53890b0337972e46504636831c1b6307b841c4c5aeec86482b2da3c1666c46e870a75f6cb54db9f759664688b382ad66efa647145d900";

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
