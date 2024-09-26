{
  lib,
  stdenv,
  fetchurl,
  mpi,
}:

stdenv.mkDerivation rec {
  pname = "hpcg";
  version = "3.1";

  src = fetchurl {
    url = "http://www.hpcg-benchmark.org/downloads/hpcg-${version}.tar.gz";
    sha256 = "197lw2nwmzsmfsbvgvi8z7kj69n374kgfzzp8pkmk7mp2vkk991k";
  };

  buildInputs = [ mpi ];

  makeFlags = [ "arch=Linux_MPI" ];

  enableParallelBuilding = true;

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/hpcg

    cp bin/xhpcg $out/bin
    cp bin/hpcg.dat $out/share/hpcg

    runHook postInstall
  '';

  meta = with lib; {
    description = "HPC conjugate gradient benchmark";
    homepage = "https://www.hpcg-benchmark.org";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    mainProgram = "xhpcg";
  };
}
