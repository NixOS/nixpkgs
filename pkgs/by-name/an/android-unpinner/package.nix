{
  lib,
  python3Packages,
  fetchFromGitHub,
  autoPatchelfHook,
  android-tools,
  androidenv,
  frida-tools,
  libfrida-core,
  aapt,
  apksigner,
}:
let
  inherit (python3Packages) buildPythonApplication hatchling rich-click;
  buildToolsVersion = "33.0.2";
  androidComposition = androidenv.composeAndroidPackages {
    buildToolsVersions = [ buildToolsVersion ];
  };
in
buildPythonApplication {
  pname = "android-unpinner";
  version = "0-unstable-2025-10-30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "android-unpinner";
    rev = "60cbfee4d43cedaff622d72c27d87e418a111413";
    sha256 = "sha256-nEkGn7RCraZuRSKp9hsVcRgE1EW6nRqEzxsGXprEd9Q=";
  };

  build-system = [ hatchling ];

  preBuild = ''
    ln -sf ${lib.getExe apksigner} android_unpinner/vendor/build_tools/linux/apksigner
    ln -sf ${lib.getExe' aapt "aapt2"} android_unpinner/vendor/build_tools/linux/aapt2
    ln -sf ${androidComposition.androidsdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/zipalign android_unpinner/vendor/build_tools/linux/zipalign
    ln -sf ${lib.getExe' android-tools "adb"} android_unpinner/vendor/platform_tools/linux/adb
  '';

  dependencies = [
    rich-click

    # https://github.com/mitmproxy/android-unpinner/tree/main/android_unpinner/vendor
    frida-tools
    libfrida-core
    #androidenv.androidPkgs.ndk-bundle
  ];

  # https://github.com/NixOS/nixpkgs/pull/442819
  pythonRelaxDeps = [ "rich-click" ];

  pythonImportsCheck = [ "android_unpinner" ];

  meta = {
    description = "Remove Certificate Pinning from APKs";
    homepage = "https://github.com/mitmproxy/android-unpinner";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
