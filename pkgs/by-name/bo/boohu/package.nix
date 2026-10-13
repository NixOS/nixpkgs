{
  lib,
  fetchurl,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "boohu";
  version = "0.14.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/boohu/downloads/boohu-${finalAttrs.version}.tar.gz";
    hash = "sha256-IB59C5/uuHP6LtKLypjpgHOo0MR9bFdCbudaRa+h7lI=";
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
    homepage = "https://download.tuxfamily.org/boohu/index.html";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
