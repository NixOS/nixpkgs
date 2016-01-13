{ stdenv, fetchurl, git, gnupg, makeWrapper, pass, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/IJHack/qtpass/archive/v${version}.tar.gz";
    sha256 = "ccad9a06e3efa23278fa3e958185bf24fb3800874d8165be4ae6649706a2ab1c";
  };

  buildInputs = [ git gnupg makeWrapper pass qtbase qttools ];

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
