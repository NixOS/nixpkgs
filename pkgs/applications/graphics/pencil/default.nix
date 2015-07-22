{ stdenv, fetchurl, makeWrapper, xulrunner }:

stdenv.mkDerivation rec {
  version = "2.0.11";
  name = "pencil-${version}";

  src = fetchurl {
    url = "https://github.com/prikhi/pencil/releases/download/v${version}/Pencil-${version}-linux-pkg.tar.gz";
    sha256 = "a35d1353de6665cbd4a5bd821dcdf7439f2a3c1fcbccee0f01ec8dd1bb67c4f3";

  };

  buildPhase = "";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out"
    sed -e "s|/usr/share/evolus-pencil|$out/share/evolus-pencil|" \
        -i "$out/bin/pencil"
    sed -e "s|/usr/bin/pencil|$out/bin/pencil|" \
        -e "s|Icon=.*|Icon=$out/share/evolus-pencil/skin/classic/icon.svg|" \
        -i "$out/share/applications/pencil.desktop"

    wrapProgram $out/bin/pencil \
      --prefix PATH ":" ${xulrunner}/bin
  '';

  meta = with stdenv.lib; {
    description = "GUI prototyping/mockup tool";
    homepage = http://github.com/prikhi/pencil;
    license = licenses.gpl2; # Commercial license is also available
    maintainers = with maintainers; [ bjornfor prikhi ];
    platforms = platforms.linux;
  };
}
