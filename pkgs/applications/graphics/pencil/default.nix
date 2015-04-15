{ stdenv, fetchurl, xulrunner }:

stdenv.mkDerivation rec {
  version = "2.0.10";
  name = "pencil-${version}";

  src = fetchurl {
    url = "https://github.com/prikhi/pencil/releases/download/v${version}/Pencil-${version}-linux-pkg.tar.gz";
    sha256 = "b5dcb12986108bf3eb13cdd1ee1fc1f8d1a88c7fadf2a5c44e7a59a254f2b0dd";
  };

  buildPhase = "";

  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out"
    sed -e "s|/usr/bin/xulrunner|${xulrunner}/bin/xulrunner|" \
        -e "s|/usr/share/evolus-pencil|$out/share/evolus-pencil|" \
        -i "$out/bin/pencil"
    sed -e "s|/usr/bin/pencil|$out/bin/pencil|" \
        -e "s|Icon=.*|Icon=$out/share/evolus-pencil/skin/classic/icon.svg|" \
        -i "$out/share/applications/pencil.desktop"
  '';

  meta = with stdenv.lib; {
    description = "GUI prototyping/mockup tool";
    homepage = http://github.com/prikhi/pencil;
    license = licenses.gpl2; # Commercial license is also available
    maintainers = with maintainers; [ bjornfor prikhi ];
    platforms = platforms.linux;
  };
}
