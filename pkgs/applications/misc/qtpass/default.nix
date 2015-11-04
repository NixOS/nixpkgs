{ stdenv, fetchurl, git, gnupg, makeWrapper, pass, qt5 }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "https://github.com/IJHack/qtpass/archive/v${version}.tar.gz";
    sha256 = "c6bcb1792f22c48844b49c5bd05f3bf5c1c2ebad249246797a273383c9f08f8c";
  };

  buildInputs = [ git gnupg makeWrapper pass qt5.base ];

  configurePhase = "qmake CONFIG+=release PREFIX=$out DESTDIR=$out";

  installPhase = ''
    mkdir $out/bin
    mv $out/qtpass $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/qtpass \
        --suffix PATH : ${git}/bin \
        --suffix PATH : ${gnupg}/bin \
        --suffix PATH : ${pass}/bin
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = https://github.com/IJHack/qtpass;
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
