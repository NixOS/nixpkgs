{ lib, stdenv
, fetchurl
, glibcLocales
, makeWrapper
, bison
, flex
, readline
, libX11
, libICE
, libXaw
, libXmu
, libXext
, libXt
, fftw
}:

stdenv.mkDerivation rec {
  pname = "ngspice";
  version = "38";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    hash = "sha256-LD4i9sR7Fl2yQc81U3Ggp1WFQKsq8/i17t7rKJoxfFY=";
  };

  nativeBuildInputs = [ flex bison makeWrapper ];
  buildInputs = [ readline libX11 libICE libXaw libXmu libXext libXt fftw ];

  # disable FORTIFY_SOURCE, since apparently the makefile compiles most
  # modules without optimization, anyway, so it doesn't take effect...
  hardeningDisable = [ "fortify" ];
  configureFlags = [
    "--enable-x"
    "--with-x"
    "--with-readline"
    "--enable-openmp"
    "--enable-xspice"
    "--enable-cider"
  ];
  enableParallelBuilding = true;

  postFixup = ''
    wrapProgram $out/bin/ngspice \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
  '';

  meta = with lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari rongcuid thoughtpolice ];
    platforms = platforms.unix;
  };
}
