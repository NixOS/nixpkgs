{
  fetchzip,
  lib,

  gtk4,
  libadwaita,
  sqlite,

  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "outlay";
  version = "1.0";
  src = fetchzip {
    url = "https://git.lashman.live/lashman/${finalAttrs.pname}/archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-Y3L5QmrycLC4aMqgsDzZAWMxrezQv/+MCoLRRnUiwA8=";
  };
  cargoHash = "sha256-hZEvrXjsrdOYmoDf/SoR1a4AZZJRz7MeVv5VCbULXhM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk4
    libadwaita
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r outlay-gtk/data/icons $out/share
  '';

  meta = {
    description = "Desktop finance app";
    homepage = "https://apps.lashman.live/outlay";
    license = lib.licenses.cc0;
    mainProgram = "outlay-gtk";
    maintainers = [ lib.maintainers.IncredibleLaser ];
  };
})
