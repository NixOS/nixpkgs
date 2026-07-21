{
  fetchFromGitHub,
  gradle,
  lib,
  REAndroidLibrary,
}:

let
  self = REAndroidLibrary {
    pname = "smali";
    version = "0-unstable-2024-11-24";
    projectName = "smali";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "smali-lib";
      # No tagged releases, and
      # it is hard to determine the actual commit that APKEditor is intended to use,
      # so I think we should use the latest commit that doesn't break compilation or basic functionality.
      # Currently this is the latest commit at the time of packaging.
      rev = "76b35b4e0c9e8c874ca3e374bb943bba8d280770";
      hash = "sha256-PhRBjiIKA4EIiafPplZNBErXG8V84Xn0cZLWVPmJelQ=";
    };

    patches = [
      # Remove this patch after REAndroid/smali-lib#1 is merged
      ./fix-gradle.patch
    ];

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };
    gradleBuildTask = "build";

    installPhase = ''
      runHook preInstall
      install -Dm644 smali/build/libs/*-fat.jar $out/${self.outJar}
      runHook postInstall
    '';

    # This fork deleted the NOTICE file from the original repo:
    # https://github.com/REAndroid/smali-lib/commit/40c075a1ff5fa8e29f339f4e71f45c028789c86c#diff-dfb14fbb9e7d095209ec4cfd621069437bf9c442ff9de9d4ce889781bd0fefcf
    # Here is the gist of the original NOTICE file:
    # Various portions of the code are from AOSP and is licensed under Apache 2.0.
    # Other parts are copyrighted by JesusFreke and Google,
    # permitting redistribution (with or without modification) of source and binary
    # as long as the copyright notice is present.
    # For full details, see:
    # https://github.com/JesusFreke/smali/blob/master/NOTICE
    meta.license = with lib.licenses; [
      asl20
      free
    ];
  };
in
self
