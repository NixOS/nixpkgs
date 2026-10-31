{
  lib,
  fetchFromCodeberg,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "boohu";
  version = "0.14.1";

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "boohu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yt5B5VjZJO64pmuYR8jSIMdCMK01gwNhFKltIR1ZCHY=";
  };

  vendorHash = "sha256-AVK4zE/Hs9SN8Qj2WYj/am2B0R74QKYoMNf3sRRjnU4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "New coffee-break roguelike game";
    mainProgram = "boohu";
    longDescription = ''
      Break Out Of Hareka's Underground (Boohu) is a roguelike game mainly
      inspired from DCSS and its tavern, with some ideas from Brogue, but
      aiming for very short games, almost no character building, and a
      simplified inventory.
    '';
    homepage = "https://codeberg.org/anaseto/boohu";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
