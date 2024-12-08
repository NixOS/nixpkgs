{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  stdenv,
}:
let

  pname = "golden-cheetah";
  version = "3.7-DEV2410";

  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${builtins.substring 0 7 version}_x64.AppImage";
    hash = "sha256-S1YDg7opoYflL/3h+lP1SNwXpJHaN3+iE3waSjWtN6o=";
  };

  appimageContents = appimageTools.extract { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [
    pkgs.R
    pkgs.zlib
    pkgs.libusb-compat-0_1
  ];

  extraInstallCommands = ''
    mv $out/bin/${pname} $out/bin/GoldenCheetah
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp ${appimageContents}/GoldenCheetah.desktop $out/share/applications/
    substituteInPlace $out/share/applications/GoldenCheetah.desktop --replace-fail \
      "Exec=GoldenCheetah" "Exec=QT_PLUGIN_PATH= GoldenCheetah"
    cp ${appimageContents}/gc.png $out/share/pixmaps/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Performance software for cyclists, runners and triathletes. This version includes the API Tokens for e.g. Strava";
    platforms = lib.platforms.linux;
    broken = !stdenv.hostPlatform.isx86_64;
    maintainers = with lib.maintainers; [
      gador
      adamcstephens
    ];
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
