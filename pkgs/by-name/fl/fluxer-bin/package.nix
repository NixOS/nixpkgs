{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "fluxer-bin";
  version = "0.0.8";

  src = fetchurl {
    url = "https://api.fluxer.app/dl/desktop/stable/linux/x64/fluxer-stable-${version}-x86_64.AppImage";
    hash = "sha256-GdoBK+Z/d2quEIY8INM4IQy5tzzIBBM+3CgJXQn0qAw=";
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  meta = with lib; {
    description = "Fluxer desktop client";
    homepage = "https://fluxer.app";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "fluxer-bin";
    maintainers = [ ];
  };
}
