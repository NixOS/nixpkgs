{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule (finalAttrs: {
  pname = "harmonist";
  version = "0.6.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "anaseto";
    repo = "harmonist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0YHbASLEcQJVYruFuWUYeb0yItmjnlJrZ4jY4h8WYgw=";
  };

  vendorHash = "sha256-pQgqITlUtKkTZTpumWUoYMIB+fKQIqbTIAeTy2UDvdY=";

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
