{ stdenv, fetchFromGitHub, qmake, pkgconfig, makeWrapper
, qtbase, qttools, qtwebkit, sqlite
}:

stdenv.mkDerivation rec {
  name = "quiterss-${version}";
  version = "0.18.12";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = "${version}";
    sha256 = "0xav9qr8n6310636nfbgx4iix65fs3ya5rz2isxsf38bkjm7r3pa";
  };

  nativeBuildInputs = [ qmake pkgconfig makeWrapper ];
  buildInputs = [ qtbase qttools qtwebkit sqlite.dev ];

  postFixup = ''
    wrapProgram $out/bin/quiterss \
      --prefix QT_PLUGIN_PATH : "${qtbase}/${qtbase.qtPluginPrefix}"
  '';

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
