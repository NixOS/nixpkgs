{ lib, stdenv, fetchurl, pkg-config, libX11, libXpm, libXext, libXfixes, libXmu }:

stdenv.mkDerivation rec {
  pname = "wmsystemtray";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${pname}-${version}.tar.gz";
     sha256 = "sha256-jt70NpHp//BxAA4pFmx8GtQgwJVukGgVEGHogcisl+k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 libXpm libXext libXfixes libXmu ];

  meta = with lib; {
    description = "A system tray for Windowmaker";
    homepage = "http://wmsystemtray.sourceforge.net";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.bstrik ];
    platforms = platforms.linux;
  };
}
