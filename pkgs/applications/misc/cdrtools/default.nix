{ stdenv, fetchurl, acl, libcap, Carbon, IOKit }:

stdenv.mkDerivation rec {
  pname = "cdrtools";
  version = "3.02a06";

  src = fetchurl {
    url = "mirror://sourceforge/cdrtools/${pname}-${version}.tar.bz2";
    sha256 = "1cayhfbhj5g2vgmkmq5scr23k0ka5fsn0dhn0n9yllj386csnygd";
  };

  patches = [ ./fix-paths.patch ];

  buildInputs = if stdenv.isDarwin then [ Carbon IOKit ] else [ acl libcap ];

  postPatch = ''
    sed "/\.mk3/d" -i libschily/Targets.man
    substituteInPlace man/Makefile --replace "man4" ""
  '';

  dontConfigure = true;

  GMAKE_NOWARN = true;

  makeFlags = [ "INS_BASE=/" "INS_RBASE=/" "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/cdrtools/;
    description = "Highly portable CD/DVD/BluRay command line recording software";
    license = with licenses; [ gpl2 lgpl2 cddl ];
    platforms = with platforms; linux ++ darwin;
    # Licensing issues: This package contains code licensed under CDDL, GPL2
    # and LGPL2. There is a debate regarding the legality of distributing this
    # package in binary form.
    hydraPlatforms = [];
  };
}
