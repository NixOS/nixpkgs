{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prodigal";
  version = "2.6.3";

  src = fetchFromGitHub {
    repo = "Prodigal";
    owner = "hyattpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ukSYGFS7Dzs5N3t4r0KcpU/1y4nWcLgzlEvigSaGQbs=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "INSTALLDIR=$(out)/bin"
  ];

  meta = {
    description = "Fast, reliable protein-coding gene prediction for prokaryotic genomes";
    mainProgram = "prodigal";
    homepage = "https://github.com/hyattpd/Prodigal";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ luispedro ];
  };
})
