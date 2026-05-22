{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "harmonist";
  version = "1.0.2";

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "harmonist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JR2EM9tlxNuntx//BV/hqsBv5fCkjjxZOcZtx+CZgIo=";
  };

  vendorHash = "sha256-0gtDnV+ofHj705nXFpZHP6imIU5G2ItQr6B17S59teI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Stealth coffee-break roguelike game";
    mainProgram = "harmonist";
    longDescription = ''
      Harmonist is a stealth coffee-break roguelike game. The game has a heavy
      focus on tactical positioning, light and noise mechanisms, making use of
      various terrain types and cones of view for monsters. Aiming for a
      replayable streamlined experience, the game avoids complex inventory
      management and character building, relying on items and player
      adaptability for character progression.
    '';
    homepage = "https://harmonist.tuxfamily.org/";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
