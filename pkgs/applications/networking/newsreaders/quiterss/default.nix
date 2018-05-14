{ stdenv, fetchFromGitHub, qtbase, qmake, qttools, qtwebkit, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "quiterss-${version}";
  version = "0.18.10";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = "${version}";
    sha256 = "1bv5aw6fscrwlycirvzm6fvbwmg8lbd1ycldkwbvybhjyfjaxkpm";
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
