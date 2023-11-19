{ lib, nim2Packages, fetchFromSourcehut, gentium, makeDesktopItem, nim_lk, SDL2 }:

nim2Packages.buildNimPackage (finalAttrs: {
  pname = "hottext";
  version = "20231003";

  nimBinOnly = true;

  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "hottext";
    rev = finalAttrs.version;
    hash = "sha256-ncH/1PV4vZY7JCUJ87FPz5bdrQsNlYxzGdc5BQNfQeA=";
  };

  buildInputs = [ SDL2 ];

  nimFlags = nim_lk.passthru.nimFlagsFromLockFile ./lock.json;

  HOTTEXT_FONT_PATH = "${gentium}/share/fonts/truetype/GentiumPlus-Regular.ttf";

  desktopItem = makeDesktopItem {
    categories = [ "Utility" ];
    comment = finalAttrs.meta.description;
    desktopName = finalAttrs.pname;
    exec = finalAttrs.pname;
    name = finalAttrs.pname;
  };

  postInstall = ''
    cp -r $desktopItem/* $out
  '';

  meta = finalAttrs.src.meta // {
    description = "Simple RSVP speed-reading utility";
    license = lib.licenses.unlicense;
    homepage = "https://git.sr.ht/~ehmry/hottext";
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "hottext";
  };
})
