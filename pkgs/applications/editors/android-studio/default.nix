{
  callPackage,
  lib,
  makeFontsConf,
  buildFHSEnv,
  stdenv,
  tiling_wm ? false,
}:

let
  mkStudio =
    opts:
    let
      inherit (opts) channel pname;
      meta = {
        description = "Official IDE for Android (${channel} channel)";
        longDescription = ''
          Android Studio is the official IDE for Android app development, based on
          IntelliJ IDEA.
        '';
        homepage =
          if channel == "stable" then
            "https://developer.android.com/studio/index.html"
          else
            "https://developer.android.com/studio/preview/index.html";
        license = with lib.licenses; [
          asl20
          unfree
        ]; # The code is under Apache-2.0, but:
        # If one selects Help -> Licenses in Android Studio, the dialog shows the following:
        # "Android Studio includes proprietary code subject to separate license,
        # including JetBrains CLion(R) (www.jetbrains.com/clion) and IntelliJ(R)
        # IDEA Community Edition (www.jetbrains.com/idea)."
        # Also: For actual development the Android SDK is required and the Google
        # binaries are also distributed as proprietary software (unlike the
        # source-code itself).
        platforms = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
        maintainers =
          rec {
            stable = with lib.maintainers; [
              alapshin
            ];
            beta = stable;
            canary = stable;
            dev = stable;
          }
          ."${channel}";
        teams =
          rec {
            stable = with lib.teams; [
              android
            ];
            beta = stable;
            canary = stable;
            dev = stable;
          }
          ."${channel}";
        mainProgram = pname;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
      builder = if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix;
    in
    callPackage (import builder (opts // { inherit meta; })) (
      if stdenv.hostPlatform.isDarwin then
        { }
      else
        {
          inherit buildFHSEnv tiling_wm;
          fontsConf = makeFontsConf {
            fontDirectories = [ ];
          };
        }
    );
  stableVersion = {
    version = "2026.2.2.9"; # "Android Studio Rabbit 2 | 2026.2.2 Patch 1"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-Eey/Dm3A8EoTU/eX5FvyOaP/GoIiFTmxuM3X6rDY2Oo=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.2.2.9/android-studio-rabbit2-patch1-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-BrefyPGPgMk/6gCNB4zhO38KXpeOPmFfasr/oK9cam0=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.2.2.9/android-studio-rabbit2-patch1-mac_arm.dmg";
      };
    };
  };
  betaVersion = {
    version = "2026.2.3.4"; # "Android Studio Rabbit 3 | 2026.2.3 RC 1"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-bnF7oZnVJ5eBURo5lU6AKWMS2OG9sqolpi8KLEDzD1g=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.2.3.4/android-studio-rabbit3-rc1-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-AC4TUcx8PB1U1iJhxQvuVU+U+ISbFfrp/pu8ZVv7lbA=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.2.3.4/android-studio-rabbit3-rc1-mac_arm.dmg";
      };
    };
  };
  latestVersion = {
    version = "2026.3.1.1"; # "Android Studio Stingray 1 | 2026.3.1 Canary 1"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-5Edwc+xCQcHCRRcs1RdwpNhwpREtswAxTPsP2/984WA=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.3.1.1/android-studio-stingray1-canary1-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-eFApCXKnGetLhkehdQTGui79LYRxrySPmLauBopkD8I=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.3.1.1/android-studio-stingray1-canary1-mac_arm.dmg";
      };
    };
  };
in
{
  # Attributes are named by their corresponding release channels

  stable = mkStudio (
    stableVersion
    // {
      channel = "stable";
      pname = "android-studio";
    }
  );

  beta = mkStudio (
    betaVersion
    // {
      channel = "beta";
      pname = "android-studio-beta";
    }
  );

  dev = mkStudio (
    latestVersion
    // {
      channel = "dev";
      pname = "android-studio-dev";
    }
  );

  canary = mkStudio (
    latestVersion
    // {
      channel = "canary";
      pname = "android-studio-canary";
    }
  );
}
