{ lib, stdenv, fetchurl, zlib, libtiff, libxml2, SDL, xorgproto, libX11
, libXi, libXmu, libXext, libGLU, libGL }:

stdenv.mkDerivation rec {
  pname = "stardust";
  version = "0.1.13";

  src = fetchurl {
    url = "http://iwar.free.fr/IMG/gz/${pname}-${version}.tar.gz";
    sha256 = "19rs9lz5y5g2yiq1cw0j05b11digw40gar6rw8iqc7bk3s8355xp";
  };

  buildInputs = [
    zlib libtiff libxml2 SDL xorgproto libX11 libXi
    libXmu libXext libGLU libGL
  ];

  installFlags = [ "bindir=\${out}/bin" ];

  hardeningDisable = [ "format" ];

  postConfigure = ''
    substituteInPlace config.h \
      --replace '#define PACKAGE ""' '#define PACKAGE "stardust"'
  '';

  meta = with lib; {
    description = "Space flight simulator";
    mainProgram = "stardust";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
