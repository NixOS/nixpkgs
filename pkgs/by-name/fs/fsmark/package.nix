{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fsmark";
  version = "3.3";

  src = fetchurl {
    url = "mirror://sourceforge/fsmark/${finalAttrs.version}/fs_mark-${finalAttrs.version}.tar.gz";
    sha256 = "15f8clcz49qsfijdmcz165ysp8v4ybsm57d3dxhhlnq1bp1i9w33";
  };

  patchPhase = ''
    sed -i Makefile -e 's/-static //'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp fs_mark $out/bin/
  '';

  meta = {
    description = "Synchronous write workload file system benchmark";
    homepage = "https://sourceforge.net/projects/fsmark/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
    mainProgram = "fs_mark";
  };
})
