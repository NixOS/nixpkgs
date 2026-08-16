{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "harmonist";
  version = "1.0.3";

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "harmonist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9cEKkvQze+hg4CwDe5epTpuQPevylwnSP5xQAVGJ/wQ=";
  };

  vendorHash = "sha256-wibNLDdykV2psOnJbMKu0EZSrrhKRxrN/OTWXmUz2FM=";

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
    changelog = "https://codeberg.org/anaseto/harmonist/src/tag/v${finalAttrs.version}/CHANGES.md";
    homepage = "https://harmonist.tuxfamily.org/";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
