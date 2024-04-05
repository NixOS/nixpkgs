{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "kmeet";
  version = "2.0.1";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/meet/kmeet-desktop-${version}-linux-x86_64.AppImage";
    name = "kmeet-${version}.AppImage";
    hash = "sha256-0lygBbIwaEydvFEfvADiL2k5GWzVpM1jX4orweriBYw=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/kmeet"
      cp -r ${contents}/{locales,resources} "$out/share/lib/kmeet"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/kMeet.desktop" "$out/share/applications/"
      mv "$out/bin/kmeet-${version}" "$out/bin/${meta.mainProgram}"
      substituteInPlace $out/share/applications/kMeet.desktop --replace 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

  meta = with lib; {
    description = "Organise secure online meetings via your web browser, your mobile, your tablet or your computer.";
    homepage = "https://www.infomaniak.com/en/apps/download-kmeet";
    license = licenses.unfree;
    maintainers = [ maintainers.vinetos ];
    mainProgram = "kmeet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    longDescription = ''
      kMeet allows you to organise secure online meetings via your web browser, your mobile, your tablet or your
      computer.
    '';
  };
}
