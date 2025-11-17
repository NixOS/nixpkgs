{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdk";
  version = "5.0-20251014";

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/cdk/cdk-${finalAttrs.version}.tgz";
    hash = "sha256-DtRpScaApfQuNCzEiizmC8/CzIue67F2h3takfgpQ1w=";
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
    ];
    inherit (ncurses.meta) platforms;
  };
})
