<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, curl
, fftw
, gmp
, gnuplot
, gtk3
, gtksourceview3
, json-glib
, lapack
, libxml2
, mpfr
, openblas
, readline
, Accelerate
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gretl";
  version = "2023b";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/gretl-${finalAttrs.version}.tar.xz";
    hash = "sha256-Hf025JjFxde43TN/1m9PeA1uHqxKTZMI8+1qf3XJLGs=";
=======
{ lib, stdenv, fetchurl, curl, fftw, gmp, gnuplot, gtk3, gtksourceview3, json-glib
, lapack, libxml2, mpfr, openblas, pkg-config, readline }:

stdenv.mkDerivation rec {
  pname = "gretl";
  version = "2023a";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/${pname}-${version}.tar.xz";
    sha256 = "sha256-T1UwQhw/Tr/juYqVJBkst2LRBCIXPLvVd0N+QCJcVtM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    curl
    fftw
    gmp
    gnuplot
    gtk3
    gtksourceview3
    json-glib
    lapack
    libxml2
    mpfr
    openblas
    readline
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Accelerate
  ];

  nativeBuildInputs = [
    pkg-config
  ];
=======
  ];

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;
  # Missing install depends:
  #  cp: cannot stat '...-gretl-2022c/share/gretl/data/plotbars': Not a directory
  #  make[1]: *** [Makefile:73: install_datafiles] Error 1
  enableParallelInstalling = false;

<<<<<<< HEAD
  meta = {
    description = "A software package for econometric analysis";
    homepage = "https://gretl.sourceforge.net";
    license = lib.licenses.gpl3;
=======
  meta = with lib; {
    description = "A software package for econometric analysis";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      gretl is a cross-platform software package for econometric analysis,
      written in the C programming language.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ dmrauh ];
    platforms = lib.platforms.all;
  };
})
=======
    homepage = "https://gretl.sourceforge.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dmrauh ];
    platforms = with platforms; all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
