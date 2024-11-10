{ lib, stdenv, fetchurl, texinfo, allegro, perl, libX11 }:

stdenv.mkDerivation rec {
  pname = "cgui";
  version="2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/cgui/${version}/${pname}-${version}.tar.gz";
    sha256 = "1pp1hvidpilq37skkmbgba4lvzi01rasy04y0cnas9ck0canv00s";
  };

  buildInputs = [ texinfo allegro perl libX11 ];

  configurePhase = ''
    sh fix.sh unix
  '';

  hardeningDisable = [ "format" ];

  makeFlags = [ "SYSTEM_DIR=$(out)" ];

  meta = with lib; {
    description = "Multiplatform basic GUI library";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.free;
  };
}
