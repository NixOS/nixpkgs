{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "fsmark";
  version = "3.3";

  src = fetchurl {
    url = "mirror://sourceforge/fsmark/${version}/fs_mark-${version}.tar.gz";
    sha256 = "15f8clcz49qsfijdmcz165ysp8v4ybsm57d3dxhhlnq1bp1i9w33";
  };

  patchPhase = ''
    sed -i Makefile -e 's/-static //'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp fs_mark $out/bin/
  '';

  meta = with lib; {
    description = "Synchronous write workload file system benchmark";
    homepage = "https://sourceforge.net/projects/fsmark/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
    mainProgram = "fs_mark";
  };
}
