{
  stdenv,
  lib,
  buildMozillaMach,
  callPackage,
  fetchurl,
  fetchpatch2,
  config,
}:

let
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
      # FIXME: let's hope that upstream will fix this soon and we can drop this hack again.
      # https://bugzilla.mozilla.org/show_bug.cgi?id=2040877
      extraPostPatch =
        lib.optionalString (lib.versionAtLeast version "151" && lib.versionOlder version "152") ''
          echo https://hg.mozilla.org/releases/comm-release/rev/becfb8fb2c70f1603882a2787e2170d5d8013949 >> sourcestamp.txt
          echo https://hg.mozilla.org/releases/mozilla-release/rev/fc12dc911f904307729760a817deb829cbf8feb4 >> sourcestamp.txt
        ''
        # https://bugzilla.mozilla.org/show_bug.cgi?id=2006630
        + lib.optionalString (lib.versionAtLeast version "140.8" && lib.versionOlder version "151") ''
          find . -name .cargo-checksum.json | xargs sed 's/"[^"]*\.gitmodules":"[a-z0-9]*",//g' -i
        '';

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
      (
        {
          geolocationSupport = false;
          webrtcSupport = false;

          pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
        }
        // lib.optionalAttrs (lib.versionAtLeast version "149") {
          # https://bugzilla.mozilla.org/show_bug.cgi?id=2025767
          crashreporterSupport = false;
        }
      );

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "152.0";
    sha512 = "51b950af634e7c7dfb7c043d69f925ed6d50d4c44341761e7e3ef02d5db28d2c539cd8d9286195e3facf84869f57b12a58760105b5195c449b4e1e4c9b6200d2";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-140;

  thunderbird-140 = common {
    applicationName = "Thunderbird ESR";

    version = "140.12.0esr";
    sha512 = "ccbcc305d5cc10aa01aa5071f40a21b42de0300d9ad6763c4fc4ad71bf797566f2380c8fd84d46952e7c4eae0a35905173e6906b108192833660eae2ceea7b51";

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
