{ stdenv, fetchurl, which, gfortran, libGLU, xorg } :

stdenv.mkDerivation rec {
  version = "5.8.2";
  name = "molden-${version}";

  src = fetchurl {
    url = "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden${version}.tar.gz";
    sha256 = "1lhjx8fa8xynnlk5g6ipvchhfnz6j5lgqxlsifx82pbbnbm6mps4";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ gfortran libGLU xorg.libX11 xorg.libXmu ];

  patches = [ ./dont_register_file_types.patch ];

  postPatch = ''
     substituteInPlace ./makefile --replace '-L/usr/X11R6/lib'  "" \
                                  --replace '-I/usr/X11R6/include' "" \
                                  --replace '/usr/local/' $out/ \
                                  --replace 'sudo' "" \
				                          --replace '-C surf depend' '-C surf'
     sed -in '/^# DO NOT DELETE THIS LINE/q;' surf/Makefile
  '';

  preInstall = ''
     mkdir -p $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
     description = "Display and manipulate molecular structures";
     homepage = http://www.cmbi.ru.nl/molden/;
     license = {
       fullName = "Free for academic/non-profit use";
       url = http://www.cmbi.ru.nl/molden/CopyRight.html;
       free = false;
     };
     platforms = platforms.linux;
     maintainers = with maintainers; [ markuskowa ];
  };
}

