{ stdenv, fetchurl, git, gnupg, makeQtWrapper, pass, qtbase, qtsvg, qttools }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/IJHack/qtpass/archive/v${version}.tar.gz";
    sha256 = "60b458062f54184057e55dbd9c93958a8bf845244ffd70b9cb31bf58697f0dc6";
  };

  buildInputs = [ git gnupg makeQtWrapper pass qtbase qtsvg qttools ];

  configurePhase = "qmake CONFIG+=release PREFIX=$out DESTDIR=$out";

  installPhase = ''
    mkdir $out/bin
    mv $out/qtpass $out/bin
  '';

  postFixup = ''
    wrapQtProgram $out/bin/qtpass \
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
