{ stdenv, fetchurl, unzip, perl, libX11, libXpm, gpm, ncurses, slang }:

stdenv.mkDerivation rec {
  name = "fte-0.50.02";

  buildInputs = [ unzip perl libX11 libXpm gpm ncurses slang ];

  ftesrc = fetchurl {
    url = "mirror://sourceforge/fte/fte-20110708-src.zip";
    sha256 = "17j9akr19w19myglw5mljjw2g3i2cwxiqrjaln82h3rz5ma1qcfn";
  };
  ftecommon = fetchurl {
    url = "mirror://sourceforge/fte/fte-20110708-common.zip";
    sha256 = "1xva4kh0674sj2b9rhf2amlr37yxmsvjkgyj89gpcn0rndw1ahaq";
  };
  src = [ ftesrc ftecommon ];

  buildFlags = "PREFIX=$(out)";

  installFlags = "PREFIX=$(out) INSTALL_NONROOT=1";

  meta = with stdenv.lib; {
    description = "A free text editor for developers";
    homepage = http://fte.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.all;
  };
}
