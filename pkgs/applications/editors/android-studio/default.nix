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
    version = "2026.1.3.8"; # "Android Studio Quail 3 | 2026.1.3 Patch 1"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-W9XuXW50exP4L7oyQTgL01jML0qEeBXI6GB1ffE9w18=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.8/android-studio-quail3-patch1-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-qnfvaRmyK+UVZtzXlgPDI/fEA/qR3HncQT7tf2oFwEg=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.1.3.8/android-studio-quail3-patch1-mac_arm.dmg";
      };
    };
  };
  betaVersion = {
    version = "2026.1.3.6"; # "Android Studio Quail 3 | 2026.1.3 RC 2"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-Mgwy+Cbx5yBCHWUEcvMfAsC1zMk3j7A5fWtMrVJgmAk=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.6/android-studio-quail3-rc2-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-5SJmTQRweFeAJsZWv0vHgK+ZtSHu0gp+al8iDGEAg+E=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.1.3.6/android-studio-quail3-rc2-mac_arm.dmg";
      };
    };
  };
  latestVersion = {
    version = "2026.1.4.4"; # "Android Studio Quail 4 | 2026.1.4 Canary 4"
    sources = {
      x86_64-linux = {
        sha256Hash = "sha256-gcVlZzJ1/euSsKVrmYLXHt1Ym2kNghTzIk6crZXhGKQ=";
        url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.4/android-studio-quail4-canary4-linux.tar.gz";
      };
      aarch64-darwin = {
        sha256Hash = "sha256-lEgZnmRbMNZ9HKC5JtjSo01MLX5hCFp7CvV67eKHGr0=";
        url = "https://edgedl.me.gvt1.com/android/studio/install/2026.1.4.4/android-studio-quail4-canary4-mac_arm.dmg";
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
