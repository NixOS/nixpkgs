{ lib, fetchurl, appimageTools, mkDesktopItem, stdenv }:

let
  pname = "remnote";
  version = "1.12.18";
  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    sha256 = "sha256-z/LTsX65rN+AJbpCTzIabpgUadFe6SnRRDKOkexZyjQ=";
  };
  icon = fetchurl {
    url = "https://www.remnote.io/icon.png";
    sha256 = "sha256-r5D7fNefKPdjtmV7f/88Gn3tqeEG8LGuD4nHI/sCk94=";
  };
  appexec = appimageTools.wrapType2 {
    inherit pname version src;
  };
  desktopItem = mkDesktopItem {
    type = "Application";
    name = "remnote";
    desktopName = "RemNote";
    comment = "Spaced Repetition";
    icon = "remnote";
    exec = "remnote %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/remnote" "x-scheme-handler/rn" ];
  };
in
stdenv.mkDerivation { 
  inherit pname version src;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install ${appexec}/bin/remnote-${version} $out/bin/remnote
    mkdir -p $out/share/applications
    install -D "${desktopItem}/share/applications/"* -t $out/share/applications/
    mkdir -p $out/share/pixmaps
    install ${icon} $out/share/pixmaps/remnote.png
    runHook postInstall
  ''; 
  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman jgarcia ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}