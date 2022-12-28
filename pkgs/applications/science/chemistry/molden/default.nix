{ lib, stdenv, fetchurl, which, gfortran, libGLU, xorg } :

stdenv.mkDerivation rec {
  version = "6.3";
  pname = "molden";

  src = fetchurl {
    url = "https://ftp.science.ru.nl/Molden//molden${version}.tar.gz";
    sha256 = "02qi16pz2wffn3cc47dpjqhfafzwfmb79waw4nnhfyir8a4h3cq1";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ gfortran libGLU xorg.libX11 xorg.libXmu ];

  patches = [ ./dont_register_file_types.patch ];

  postPatch = ''
     substituteInPlace ./makefile --replace '-L/usr/X11R6/lib'  "" \
                                  --replace '-I/usr/X11R6/include' "" \
                                  --replace '/usr/local/' $out/ \
                                  --replace 'sudo' "" \
                                  --replace '-C surf depend' '-C surf' \
                                  --replace 'FFLAGS =' 'FFLAGS = -fallow-argument-mismatch'

     substituteInPlace ambfor/makefile --replace 'FFLAGS =' 'FFLAGS = -fallow-argument-mismatch'

     sed -in '/^# DO NOT DELETE THIS LINE/q;' surf/Makefile
  '';

  preInstall = ''
     mkdir -p $out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
     description = "Display and manipulate molecular structures";
     homepage = "http://www3.cmbi.umcn.nl/molden/";
     license = {
       fullName = "Free for academic/non-profit use";
       url = "http://www3.cmbi.umcn.nl/molden/CopyRight.html";
       free = false;
     };
     platforms = platforms.linux;
     maintainers = with maintainers; [ markuskowa ];
  };
}
