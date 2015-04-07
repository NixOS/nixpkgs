{ stdenv, fetchurl, xulrunner }:

stdenv.mkDerivation rec {
  version = "2.0.8";
  name = "pencil-${version}";

  src = fetchurl {
    url = "https://github.com/prikhi/pencil/releases/download/v${version}/Pencil-${version}-linux-pkg.tar.gz";
    sha256 = "3426d0222b213649e448b06384556718c833667394f442682ff66da3cda1b881";
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
