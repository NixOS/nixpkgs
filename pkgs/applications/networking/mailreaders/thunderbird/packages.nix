{
  stdenv,
  lib,
  buildMozillaMach,
  callPackage,
  fetchurl,
  icu73,
  fetchpatch2,
  config,
}:

let
  icu73' = icu73.overrideAttrs (attrs: {
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
      binaryName = pname;
      src = fetchurl {
        url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
        inherit sha512;
      };
      extraPatches = [
        # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
        ./no-buildconfig.patch
        # clang-19 fixes for char_traits build issue
        # https://github.com/rnpgp/rnp/pull/2242/commits/e0790a2c4ff8e09d52522785cec1c9db23d304ac
        # https://github.com/rnpgp/sexpp/pull/54/commits/46744a14ffc235330bb99cebfaf294829c31bba4
        # Remove when upstream bumps bundled rnp version: https://bugzilla.mozilla.org/show_bug.cgi?id=1893950
        ./0001-Removed-lookup-against-basic_string-uint8_t.patch
        ./0001-Implemented-char_traits-for-SEXP-octet_t.patch
      ];

      extraPassthru = {
        icu73 = icu73';
      };

      meta = with lib; {
        changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
        description = "Full-featured e-mail client";
        homepage = "https://thunderbird.net/";
        mainProgram = "thunderbird";
        maintainers = with maintainers; [
          lovesegfault
          pierron
          vcunat
        ];
        platforms = platforms.unix;
        broken = stdenv.buildPlatform.is32bit;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = licenses.mpl20;
      };
    }).override
      {
        geolocationSupport = false;
        webrtcSupport = false;

        pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

        icu73 = icu73';
      };

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "137.0.2";
    sha512 = "6cc631d14780f1bf9224208881c14834cef078688ffa006f50dfdd3a4e81c95255fb455f530a09a0f296dc494af104aefe2414ac53c6b8c9956ca1a9d7a7e053";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-128;

  thunderbird-128 = common {
    applicationName = "Thunderbird ESR";

    version = "128.9.2esr";
    sha512 = "3c8df53304611c1a7f8c02d50cfa1017f4d64c50a93fd6603ce0766cbb5d63c7bc5e0276f155c35817c3efa49f683c05583ddf24257bf8c25f585b67fd732cb5";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-128";
      versionPrefix = "128";
      versionSuffix = "esr";
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
  thunderbird-115 = throw "Thunderbird 115 support ended in October 2024";
}
