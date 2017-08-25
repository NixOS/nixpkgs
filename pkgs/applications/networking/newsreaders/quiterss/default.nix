{ stdenv, fetchFromGitHub, qtbase, qmake, qttools, qtwebkit, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "quiterss-${version}";
  version = "0.18.7";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = "${version}";
    sha256 = "031n07s8dd0n3d5d4v9pza59iyvaim484n1qdnpbgamls2p8iwn6";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtbase qttools qtwebkit sqlite.dev ];

  meta = with stdenv.lib; {
    description = "A Qt-based RSS/Atom news feed reader";
    longDescription = ''
      QuiteRSS is a open-source cross-platform RSS/Atom news feeds reader
      written on Qt/C++
    '';
    homepage = https://quiterss.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
