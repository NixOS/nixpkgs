{ mkDerivation, lib, stdenv, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwebsockets, qtx11extras
, qtwayland }:

mkDerivation rec {
  pname = "qownnotes";
  version = "21.7.4";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Fetch the checksum of current version with curl:
    # curl https://download.tuxfamily.org/qownnotes/src/qownnotes-<version>.tar.xz.sha256
    sha256 = "3957dc623b419582ef7ccc5cb04b8f97bed4e96e8ecc2e99bef9dca7ce255b8e";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets qtx11extras ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration.";
    longDescription = "QOwnNotes is a plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration.";
    homepage = "https://www.qownnotes.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dtzWill totoroot ];
    platforms = platforms.linux;
  };
}
