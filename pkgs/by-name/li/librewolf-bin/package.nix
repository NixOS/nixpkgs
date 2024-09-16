{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "librewolf-bin";
  upstreamVersion = "129.0.2-1";
  version = lib.replaceStrings [ "-" ] [ "." ] upstreamVersion;
  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/${upstreamVersion}/LibreWolf.x86_64.AppImage";
    hash = "sha256-h4SZnI2BwCSsLADYIxTXu82Jyst1hqYGHt54MnluLss=";
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

  meta = {
    description = "Fork of Firefox, focused on privacy, security and freedom (upstream AppImage release)";
    homepage = "https://librewolf.net";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "librewolf";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
