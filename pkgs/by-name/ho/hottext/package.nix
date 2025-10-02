{
  lib,
  buildNimPackage,
  fetchFromSourcehut,
  gentium-plus,
  makeDesktopItem,
}:

buildNimPackage (finalAttrs: {
  pname = "hottext";
  version = "20231003";

  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "hottext";
    rev = finalAttrs.version;
    hash = "sha256-ncH/1PV4vZY7JCUJ87FPz5bdrQsNlYxzGdc5BQNfQeA=";
  };

  lockFile = ./lock.json;

  HOTTEXT_FONT_PATH = "${gentium-plus}/share/fonts/truetype/GentiumPlus-Regular.ttf";

  desktopItem = makeDesktopItem {
    categories = [ "Utility" ];
    comment = finalAttrs.meta.description;
    desktopName = "hottext";
    exec = "hottext";
    name = "hottext";
  };

  postInstall = ''
    cp -r $desktopItem/* $out
  '';

  meta = finalAttrs.src.meta // {
    description = "Simple RSVP speed-reading utility";
    license = lib.licenses.unlicense;
    homepage = "https://git.sr.ht/~ehmry/hottext";
    mainProgram = "hottext";
  };
})
