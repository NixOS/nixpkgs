<<<<<<< HEAD
{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_25 }:

stdenv.mkDerivation rec {
  pname = "blockbench-electron";
  version = "4.8.1";

  src = fetchurl {
    url = "https://github.com/JannisX11/blockbench/releases/download/v${version}/Blockbench_${version}.AppImage";
    sha256 = "sha256-CE2wDOt1WBcYmPs4sEyZ3LYvKLequFZH0B3huMYHlwA=";
=======
{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_22 }:

stdenv.mkDerivation rec {
  pname = "blockbench-electron";
  version = "4.5.2";

  src = fetchurl {
    url = "https://github.com/JannisX11/blockbench/releases/download/v${version}/Blockbench_${version}.AppImage";
    sha256 = "sha256-uUgVBdYMCF31+L/FV4ADIpUdEAmnW59KfscQxUStPWM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/blockbench.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
<<<<<<< HEAD
    makeWrapper ${electron_25}/bin/electron $out/bin/${pname} \
=======
    makeWrapper ${electron_22}/bin/electron $out/bin/${pname} \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A boxy 3D model editor powered by Electron";
    homepage = "https://blockbench.net/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ckie ];
    platforms = [ "x86_64-linux" ];
  };
}
