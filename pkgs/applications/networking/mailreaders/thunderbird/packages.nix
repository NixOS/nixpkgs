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
      broken ? stdenv.buildPlatform.is32bit,
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
      ++
        lib.optional (lib.versionAtLeast version "154" && lib.versionOlder version "154.0.1")
          (fetchpatch2 {
            # Fix Success macros colliding: https://bugzilla.mozilla.org/show_bug.cgi?id=2065007
            url = "https://github.com/mozilla-firefox/firefox/commit/f0b76eba072821d62e74ebdbd8da9243a2ce3b84.patch";
            hash = "sha256-PCTmv1ZO7ce4q5fp+WPmy5Wga5OMY4hNzqIZ7iYCcp4=";
          });
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
        inherit broken;
        changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
        description = "Full-featured e-mail client";
        homepage = "https://www.thunderbird.net/";
        donationPage = "https://www.thunderbird.net/donate/";
        mainProgram = "thunderbird";
        maintainers = with lib.maintainers; [
          booxter # darwin
          lovesegfault
          pierron
          vcunat
        ];
        platforms = lib.platforms.unix;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = lib.licenses.mpl20;
      };
    }).override
      (
        {
          enableLocation = false;
          enableWebRTC = false;

          enablePGO = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
        }
        // lib.optionalAttrs (lib.versionAtLeast version "149") {
          # https://bugzilla.mozilla.org/show_bug.cgi?id=2025767
          enableCrashReporter = false;
        }
      );

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "157.0.1";
    sha512 = "12c6151150cadce68b113720788ff6d4cdcd39ae57131152f92a272a76c2590fd929edd45faed4e81e1f32eb58d0b22ca003a37294b9daf6648d39194f09fd95";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-153;

  thunderbird-153 = common {
    applicationName = "Thunderbird ESR";

    version = "153.4.0esr";
    sha512 = "93c43a75010b2edd36c58d054cd2e15a879b9e62e21f419bd8c7f97b8f7f6f29e8aed9d445ab9ccebdc1825dbf0f5e82e6e316c5f817f877d64266a2f2dbf9ec";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-153";
      versionPrefix = "153";
      versionSuffix = "esr";
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
  thunderbird-115 = throw "Thunderbird 115 support ended in October 2024";
  thunderbird-128 = throw "Thunderbird 128 support ended in August 2025";
  thunderbird-140 = throw "Thunderbird 140 has been removed. Use thunderbird-esr instead.";
}
