{ lib, stdenv, fetchurl, python3, asciidoc }:

stdenv.mkDerivation rec {
  pname = "eweb";
  version = "9.10";

  src = fetchurl {
    url = "mirror://sourceforge/project/eweb/${pname}-${version}.tar.bz2";
    sha256 = "1xy7vm2sj5q6s620fm25klmnwnz9xkrxmx4q2f8h6c85ydisayd5";
  };

  buildInputs = [ python3 asciidoc ];

  installPhase = ''
    install -d $out/bin $out/share/doc/${pname}-${version}
    cp etangle.py $out/bin
    cp etangle.w etangle.html $out/share/doc/${pname}-${version}
  '';

  meta = with lib; {
    homepage = "https://eweb.sourceforge.net/";
    description = "Asciidoc-based literate programming tool, written in Python";
    mainProgram = "etangle.py";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
