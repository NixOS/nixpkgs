{ stdenv, fetchFromGitHub, qt5, qmakeHook, makeQtWrapper, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "quiterss-${version}";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = "${version}";
    sha256 = "1y0n5ps1z4wgf9hkfjrw7dfyncrw22bf9mi3052vmf3s7xzz6vbb";
  };

  buildInputs = [ qt5.qtbase qt5.qttools qt5.qtwebkit qmakeHook makeQtWrapper pkgconfig sqlite.dev ];

  postInstall = ''
    wrapQtProgram "$out/bin/quiterss"
  '';

  meta = with stdenv.lib; {
    description = "A Qt-based RSS/Atom news feed reader";
    longDescription = ''
      QuiteRSS is a open-source cross-platform RSS/Atom news feeds reader
      written on Qt/C++
    '';
    homepage = "https://quiterss.org";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
