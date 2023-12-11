{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem }:

stdenv.mkDerivation (finalAttrs: let
  inherit (finalAttrs) pname version src appexec icon desktopItem;

in
{
  pname = "remnote";
  version = "1.13.0";

  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    hash = "sha256-ovM7MnRqzy/mgz+h87hqIuvquODIfmxjdJG1NZYobbk=";
  };
  appexec = appimageTools.wrapType2 {
    inherit pname version src;
  };
  icon = fetchurl {
    url = "https://www.remnote.io/icon.png";
    hash = "sha256-r5D7fNefKPdjtmV7f/88Gn3tqeEG8LGuD4nHI/sCk94=";
  };
  desktopItem = makeDesktopItem {
    type = "Application";
    name = "remnote";
    desktopName = "RemNote";
    comment = "Spaced Repetition";
    icon = "remnote";
    exec = "remnote %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/remnote" "x-scheme-handler/rn" ];
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -D ${appexec}/bin/remnote-${version} $out/bin/remnote
    install -D "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -D ${icon} $out/share/pixmaps/remnote.png

    runHook postInstall
  '';
  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman chewblacka ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "remnote";
  };
})
