{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "bvi";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/bvi/${pname}-${version}.src.tar.gz";
    sha256 = "0a0yl0dcyff31k3dr4dpgqmlwygp8iaslnr5gmb6814ylxf2ad9h";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Hex editor with vim style keybindings";
    homepage = "https://bvi.sourceforge.net/download.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
