{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdk";
  version = "5.0-20250116";

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/cdk/cdk-${finalAttrs.version}.tgz";
    hash = "sha256-FQDUEiTVC3JyjMr+I8TuCWvIU1/W/bnodtpM3u3a3IM=";
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
