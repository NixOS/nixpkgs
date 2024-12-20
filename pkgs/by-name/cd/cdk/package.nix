{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdk";
  version = "5.0-20240619";

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/cdk/cdk-${finalAttrs.version}.tgz";
    hash = "sha256-Q28U6KdW5j3f9ZJ+73DJ3PceTFnVZYfiYwKk9yahnv8=";
  };

  buildInputs = [
    ncurses
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Curses development kit";
    mainProgram = "cdk5-config";
    homepage = "https://invisible-island.net/cdk/";
    changelog = "https://invisible-island.net/cdk/CHANGES.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
      AndersonTorres
    ];
    inherit (ncurses.meta) platforms;
  };
})
