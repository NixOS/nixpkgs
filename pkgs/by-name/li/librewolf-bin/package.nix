{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "librewolf-bin";
  upstreamVersion = "134.0-1";
  version = lib.replaceStrings [ "-" ] [ "." ] upstreamVersion;
  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/${upstreamVersion}/LibreWolf.x86_64.AppImage";
    hash = "sha256-WlI0a2Sb59O6QGZ59vseTeDIkzyJd4/VIZ/qTFcLWm0=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname},librewolf}
    install -Dm444 ${appimageContents}/io.gitlab.LibreWolf.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/librewolf.png -t $out/share/pixmaps
  '';

  meta = with lib; {
    description = "Fork of Firefox, focused on privacy, security and freedom (upstream AppImage release)";
    homepage = "https://librewolf.net";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dwrege ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "librewolf";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
