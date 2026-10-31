{
  lib,
  stdenv,
  appimageTools,
  nix-update-script,
  fetchurl,
  makeWrapper,
  _7zz,
}:

let
  pname = "golden-cheetah";
  version = "3.8";

  meta = {
    description = "Performance software for cyclists, runners and triathletes. This version includes the API Tokens for e.g. Strava";
    homepage = "https://github.com/GoldenCheetah/GoldenCheetah";
    changelog = "https://github.com/GoldenCheetah/GoldenCheetah/releases/tag/v${version}";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      gador
      adamcstephens
    ];
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--url=https://github.com/GoldenCheetah/GoldenCheetah"
        "--version-regex=v([0-9\\.]*)"
      ]
      ++ (if stdenv.hostPlatform.isDarwin then [ "--subpackage=linux" ] else [ "--subpackage=darwin" ]);
    };
    inherit darwin linux;
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      passthru
      ;

    src = fetchurl {
      url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${builtins.substring 0 7 version}_arm64.dmg";
      hash = "sha256-mOdaYtdqR4O5IpPuZ40gng64/WtNKHVU7H86EYMk4LM=";
    };

    nativeBuildInputs = [
      makeWrapper
      _7zz
    ];
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications/GoldenCheetah.app"
      cp -r * "$out/Applications/GoldenCheetah.app/"
      makeWrapper "$out/Applications/GoldenCheetah.app/Contents/MacOS/GoldenCheetah" "$out/bin/GoldenCheetah"
      runHook postInstall
    '';
  };
  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit
      pname
      version
      meta
      passthru
      ;

    src = fetchurl {
      url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${builtins.substring 0 7 version}_x64.AppImage";
      hash = "sha256-qOluTrvyUEQ89B/brIKJKlZxVkZRVpswCysNW7VJFy0=";
    };

    extraPkgs = pkgs: [
      pkgs.R
      pkgs.zlib
      pkgs.libusb-compat-0_1
    ];

    appimageContents = appimageTools.extract { inherit (finalAttrs) pname src version; };

    extraInstallCommands = ''
      mv $out/bin/${pname} $out/bin/GoldenCheetah
      mkdir -p $out/share/applications
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${finalAttrs.appimageContents}/GoldenCheetah.desktop $out/share/applications/
      substituteInPlace $out/share/applications/GoldenCheetah.desktop --replace-fail \
        "Exec=GoldenCheetah" "Exec=env QT_PLUGIN_PATH= GoldenCheetah"
      cp ${finalAttrs.appimageContents}/gc.png $out/share/icons/hicolor/512x512/apps/
    '';
  });
in

if stdenv.hostPlatform.isDarwin then darwin else linux
