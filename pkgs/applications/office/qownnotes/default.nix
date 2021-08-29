{ mkDerivation, lib, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets, stdenv, qtx11extras }:

mkDerivation rec {
  pname = "qownnotes";
  version = "21.4.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-21.4.0.tar.xz.sha256
    sha256 = "bda454031a79a768b472677036ada7501ea430482277f1694757066922428eec";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [
    qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets qtx11extras
  ] ++ lib.optional stdenv.isLinux qtwayland;

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and ownCloud / Nextcloud integration";

    homepage = "https://www.qownnotes.org/";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dtzWill totoroot ];
  };
}
