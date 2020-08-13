{ stdenv
, fetchurl
, appimageTools
, makeWrapper
, electron_9
}:

let
  electron = electron_9;
in
stdenv.mkDerivation rec {
  pname = "jitsi-meet-electron";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/jitsi/jitsi-meet-electron/releases/download/v${version}/jitsi-meet-x86_64.AppImage";
    sha256 = "0gqyqjj69x1gxwj4zhwazddnj5xzy598xqz7vwkpdm1ldzna2iyj";
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
    cp -a ${appimageContents}/jitsi-meet.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with stdenv.lib; {
    description = "Jitsi Meet desktop application powered by Electron";
    homepage = "https://github.com/jitsi/jitsi-meet-electron";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = [ "x86_64-linux" ];
  };
}
