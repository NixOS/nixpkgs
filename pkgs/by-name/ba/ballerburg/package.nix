{
  lib,
  stdenv,
  fetchurl,
  fetchgit,
  cmake,
  SDL,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
}:

let
  icon = fetchurl {
    url = "https://baller.tuxfamily.org/king.png";
    hash = "sha256-HoL02xd4XkiegF/CueBDV4ppbR+6iUPllRwRow+CAvc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ballerburg";
  version = "1.2.3";

  src = fetchgit {
    url = "https://framagit.org/baller/ballerburg.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rO7ixLE+EV6zd0EryHU6QZeVoa6N4fvxwoJWa0aO70=";
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [ SDL ];

  desktopItems = [
    (makeDesktopItem {
      name = "Ballerburg";
      desktopName = "Ballerburg SDL";
      exec = "_NET_WM_ICON=ballerburg ballerburg";
      comment = finalAttrs.meta.description;
      icon = "ballerburg";
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    # Generate and install icon files
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert ${icon} -sample "$size"x"$size" \
        -background white -gravity south -extent "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/ballerburg.png
    done
  '';

  meta = {
    description = "Classic cannon combat game";
    mainProgram = "ballerburg";
    longDescription = ''
      Two castles, separated by a mountain, try to defeat each other with their cannonballs,
      either by killing the opponent's king or by weakening the opponent enough so that the king capitulates.'';
    homepage = "https://baller.tuxfamily.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    platforms = lib.platforms.all;
  };
})
