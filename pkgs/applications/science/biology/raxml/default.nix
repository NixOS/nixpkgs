{ lib, stdenv
, fetchFromGitHub
, useMpi ? false
, mpi
}:

stdenv.mkDerivation rec {
  pname = "RAxML${lib.optionalString useMpi "-mpi"}";
  version = "8.2.12";

  src = fetchFromGitHub {
    owner = "stamatak";
    repo = "standard-RAxML";
    rev = "v${version}";
    sha256 = "1jqjzhch0rips0vp04prvb8vmc20c5pdmsqn8knadcf91yy859fh";
  };

  buildInputs = lib.optionals useMpi [ mpi ];

  # TODO darwin, AVX and AVX2 makefile targets
  buildPhase = if useMpi then ''
      make -f Makefile.MPI.gcc
    '' else ''
      make -f Makefile.SSE3.PTHREADS.gcc
    '';

  installPhase = if useMpi then ''
    mkdir -p $out/bin && cp raxmlHPC-MPI $out/bin
  '' else ''
    mkdir -p $out/bin && cp raxmlHPC-PTHREADS-SSE3 $out/bin
  '';

  meta = with lib; {
    description = "A tool for Phylogenetic Analysis and Post-Analysis of Large Phylogenies";
    license = licenses.gpl3;
    homepage = "https://sco.h-its.org/exelixis/web/software/raxml/";
    maintainers = [ maintainers.unode ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
