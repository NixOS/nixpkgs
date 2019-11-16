{ stdenv, fetchFromGitHub, qmake, pkgconfig, wrapQtAppsHook
, qtbase, qttools, qtwebkit, sqlite
}:

stdenv.mkDerivation rec {
  pname = "quiterss";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = version;
    sha256 = "1czz8n21f4iaazvkq37m867bqy40sdkj44bqggfjcw49pl60kvjn";
  };

  nativeBuildInputs = [ qmake pkgconfig wrapQtAppsHook ];
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
