{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "markmind";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/MarkMindCkm/Mark-Mind/releases/download/v${version}/Mark.Mind-${version}.AppImage";
    sha256 = "sha256-iOJ0IOIzleA69rv94Qd35rMbHc+XSi8OPatf2V6sYrI=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "markmind-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/markmind $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/markmind
    cp -a ${appimageContents}/mind.desktop $out/share/applications/markmind.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/markmind.desktop \
      --replace 'Exec=AppRun' 'Exec=markmind'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/markmind \
      --add-flags $out/share/markmind/resources/app.asar
  '';

  meta = with lib; {
    description = "Mind map and outliner editor";
    homepage = "https://github.com/MarkMindCkm/Mark-Mind";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
