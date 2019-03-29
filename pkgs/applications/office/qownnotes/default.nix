{ stdenv, fetchurl, qmake, qttools, qtbase, qtsvg, qttranslations, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets }:

stdenv.mkDerivation rec {
  pname = "qownnotes";
  version = "19.3.4";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-19.1.8.tar.xz.sha256
    sha256 = "4e2d25acf596ed3a759b298e39f6f8bea001c0625e143616bf97560913d7f86f";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [
    qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets
  ] ++ stdenv.lib.optional stdenv.isLinux qtwayland;

  meta = with stdenv.lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and ownCloud / Nextcloud integration";

    homepage = https://www.qownnotes.org/;
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
