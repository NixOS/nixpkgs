{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  qmake,
  wrapQtAppsHook,
  chmlib,
  libzip,
  qtwebengine,
}:

stdenv.mkDerivation rec {
  pname = "kchmviewer";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "RELEASE_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-YNpiBf6AFBCRbAZRPODvqGbQQedJJJrZFQIQyzIeBlw=";
  };

  patches = [
    # remove unused webkit
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/a4a3984465cb635822953350c571950ae726b539.patch";
      sha256 = "sha256-nHW18a4SrTG4fETJmKS4ojHXwnX1d1uN1m4H0GIuI28=";
    })
    # QtWebengine fixes
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/9ac73e7ad15de08aab6b1198115be2eb44da7afe.patch";
      sha256 = "sha256-qg2ytqA2On7jg19WZmHIOU7vLQI2hoyqItySLEA64SY=";
    })
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/99a6d94bdfce9c4578cce82707e71863a71d1453.patch";
      sha256 = "sha256-o8JkaMmcJObmMt+o/6ooCAPCi+yRAWDAgxV+tR5eHfY=";
    })
  ];

  buildInputs = [
    chmlib
    libzip
    qtwebengine
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  postInstall = ''
    install -Dm755 bin/kchmviewer -t $out/bin
    install -Dm644 packages/kchmviewer.png -t $out/share/pixmaps
    install -Dm644 packages/kchmviewer.desktop -t $out/share/applications
  '';

  meta = with lib; {
    description = "CHM (Winhelp) files viewer";
    mainProgram = "kchmviewer";
    homepage = "http://www.ulduzsoft.com/linux/kchmviewer/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
