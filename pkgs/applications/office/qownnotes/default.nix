{ mkDerivation, lib, stdenv, fetchurl
, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwebsockets
, qtx11extras, qtwayland
}:

mkDerivation rec {
  pname = "qownnotes";
  version = "22.8.1";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Fetch the checksum of current version with curl:
    # curl https://download.tuxfamily.org/qownnotes/src/qownnotes-<version>.tar.xz.sha256
    sha256 = "82b231c53c485671568571e97f34b98887b0cee6e8a336a61e7d490edc605061";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets qtx11extras ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration.";
    longDescription = "QOwnNotes is a plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration.";
    homepage = "https://www.qownnotes.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.linux;
  };
}
