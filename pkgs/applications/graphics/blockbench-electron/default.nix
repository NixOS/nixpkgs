{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_16 }:

stdenv.mkDerivation rec {
  pname = "blockbench-electron";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/JannisX11/blockbench/releases/download/v${version}/Blockbench_${version}.AppImage";
    sha256 = "0mqdkjhmylrjjfrm05jv1967qqka5263fgcn9qzax08gcq93s18f";
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
    makeWrapper ${electron_16}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A boxy 3D model editor powered by Electron";
    homepage = "https://blockbench.net/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.ckie ];
    platforms = [ "x86_64-linux" ];
  };
}
