{
  mkDerivation,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qtbase,
  qttools,
  qtx11extras,
  poppler,
}:

mkDerivation rec {
  pname = "qcomicbook";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "stolowski";
    repo = "QComicBook";
    rev = version;
    sha256 = "1b769lp6gfwds4jb2g7ymhdm9c06zg57zpyz3zpdb40w07zfsjzv";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    poppler
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/*.desktop \
      --replace "Exec=qcomicbook" "Exec=$out/bin/qcomicbook"
  '';

  meta = with lib; {
    homepage = "https://github.com/stolowski/QComicBook";
    description = "Comic book reader in Qt5";
    mainProgram = "qcomicbook";
    license = licenses.gpl2;

    longDescription = ''
      QComicBook is a viewer for PDF files and comic book archives containing
      jpeg/png/xpm/gif/bmp images, which aims at convenience and simplicity.
      Features include: automatic unpacking of archive files, full-screen mode, continuous
      scrolling mode, double-pages viewing, manga mode, thumbnails view, page scaling,
      mouse or keyboard navigation etc.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ greydot ];
  };
}
