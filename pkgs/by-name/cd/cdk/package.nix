{ lib
, stdenv
, fetchurl
, ncurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdk";
  version = "5.0-20230201";

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/cdk/cdk-${finalAttrs.version}.tgz";
    hash = "sha256-oxJ7Wf5QX16Jjao90VsM9yShJ0zmgWW3eb4vKdTE8vY=";
  };

  buildInputs = [
    ncurses
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Curses development kit";
    homepage = "https://invisible-island.net/cdk/";
    changelog = "https://invisible-island.net/cdk/CHANGES.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin AndersonTorres ];
    inherit (ncurses.meta) platforms;
  };
})
