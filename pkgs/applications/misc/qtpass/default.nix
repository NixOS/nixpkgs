{ stdenv, fetchurl, git, gnupg, makeWrapper, pass, qt5 }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "https://github.com/IJHack/qtpass/archive/v${version}.tar.gz";
    sha256 = "0c07bd1eb9e5336c0225f891e5b9a9df103f218619cf7ec6311edf654e8db281";
  };

  buildInputs = [ git gnupg makeWrapper pass qt5.base qt5.tools];

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
