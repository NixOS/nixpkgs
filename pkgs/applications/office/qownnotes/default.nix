{ mkDerivation, lib, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets, stdenv, qtx11extras }:

mkDerivation rec {
  pname = "qownnotes";
  version = "21.3.2";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-21.3.2.tar.xz.sha256
    sha256 = "a8e8ab2ca1ef6684407adeb8fc63abcafff407a367471e053c583a1c4215e5ee";
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
