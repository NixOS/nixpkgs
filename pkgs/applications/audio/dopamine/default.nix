{ appimageTools, lib, fetchurl }:

let
  pversion = "3.0.0-preview.19";
in
appimageTools.wrapType2 rec {
  pname = "dopamine";
  version = "3.0.0-preview19";

  src = fetchurl {
    url = "https://github.com/digimezzo/dopamine/releases/download/v${version}/Dopamine-${pversion}.AppImage";
    sha256 = "sha256-TadvdoVOixTw2SglEuCFZvF0yfmu2TLmwOdB/odycbM=";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "The audio player that keeps it simple";
    homepage = "https://github.com/digimezzo/dopamine";
    license = licenses.gpl3;
    maintainers = [ maintainers.yaoshiu ];
    platforms = [ "x86_64-linux" ];
  };
}
