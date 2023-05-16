<<<<<<< HEAD
{ appimageTools, lib, fetchurl, nix-update-script, stdenv }:
let

  pname = "golden-cheetah";
  version = "3.6";

  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${version}_x64.AppImage";
    hash = "sha256-PMRUDQSQxbECbF9SPOo03t4Xxj1OtYJAPXEMyyy6EVY=";
=======
{ appimageTools, lib, fetchurl, stdenv }:
let

  pname = "golden-cheetah";
  version = "3.6-RC4";

  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v3.6-DEV_x64.AppImage";
    hash = "sha256-I5GafK/W1djSx67xrjcMyPqMSqGW9AfrcPYcGcf0Pag=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  appimageContents = appimageTools.extract { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: with pkgs; [ R zlib libusb-compat-0_1 ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/GoldenCheetah
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp ${appimageContents}/GoldenCheetah.desktop $out/share/applications/
    cp ${appimageContents}/gc.png $out/share/pixmaps/
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Performance software for cyclists, runners and triathletes. This version includes the API Tokens for e.g. Strava";
    platforms = lib.platforms.linux;
    broken = !stdenv.isx86_64;
    maintainers = with lib.maintainers; [ gador adamcstephens ];
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
=======
  meta = with lib; {
    description = "Performance software for cyclists, runners and triathletes. This version includes the API Tokens for e.g. Strava";
    platforms = platforms.linux;
    broken = !stdenv.isx86_64;
    maintainers = with maintainers; [ gador ];
    license = licenses.gpl2Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
