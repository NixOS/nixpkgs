{
  chromium
, fetchurl
, lib
, stdenvNoCC
, undmg

, channel
, meta
}:

with lib.strings;

let
  version = chromium.upstream-info.version_darwin;
  suffix = if channel != "stable" then "-" + channel else "";
  downloadSuffix = if channel == "stable" then "" else channel;
  channelPath = if channel == "stable" then "stable/CHFA" else channel;

  capitalize = s: (toUpper (builtins.head s)) + (substring 0 (stringLength(s) s));
  appSuffix = if channel == "stable" then "" else " ${capitalize channel}";
in
  stdenvNoCC.mkDerivation {
    inherit version;

    name = "google-chrome${suffix}-${version}";

    # https://www.chromium.org/getting-involved/dev-channel/
    src = fetchurl {
      # https://dl.google.com/chrome/mac/universal/canary/googlechromecanary.dmg
      # https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg
      # https://dl.google.com/chrome/mac/universal/beta/googlechromebeta.dmg
      url = "https://dl.google.com/chrome/mac/universal/${channelPath}/googlechrome${downloadSuffix}.dmg";
      sha256 = chromium.upstream-info.sha256_darwin;
    };
    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r "Google Chrome${appSuffix}.app" "$out/Applications"
    '';

    meta = with lib; meta // {
      platforms = [ "x86_64-darwin" "aarch64-darwin" ];
      maintainers = with maintainers; [ steinybot ];
    };
  }
