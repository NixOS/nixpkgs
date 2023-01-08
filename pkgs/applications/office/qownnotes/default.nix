{ mkDerivation, lib, stdenv, fetchurl
, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwebsockets
, qtx11extras, qtwayland
, makeWrapper
}:

mkDerivation rec {
  pname = "qownnotes";
  version = "22.12.3";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-fpI7RYOGmWwmau6tF8FPmY2/FtN9foWRX8/WgrNU6E8=";
  };

  nativeBuildInputs = [ qmake qttools ]
    ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [ qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets qtx11extras ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/QOwnNotes.app $out/Applications
    makeWrapper $out/Applications/QOwnNotes.app/Contents/MacOS/QOwnNotes $out/bin/QOwnNotes
  '';

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    license = licenses.gpl2Only;
    mainProgram = "QOwnNotes";
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.unix;
  };
}
