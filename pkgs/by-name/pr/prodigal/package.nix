{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "prodigal";
  version = "2.6.3";

  src = fetchFromGitHub {
    repo = "Prodigal";
    owner = "hyattpd";
    rev = "v${version}";
    sha256 = "1fs1hqk83qjbjhrvhw6ni75zakx5ki1ayy3v6wwkn3xvahc9hi5s";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "INSTALLDIR=$(out)/bin"
  ];

  meta = with lib; {
    description = "Fast, reliable protein-coding gene prediction for prokaryotic genomes";
    mainProgram = "prodigal";
    homepage = "https://github.com/hyattpd/Prodigal";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ luispedro ];
  };
}
