{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  qt5,
  chmlib,
  libzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kchmviewer";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = "kchmviewer";
    tag = "RELEASE_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-YNpiBf6AFBCRbAZRPODvqGbQQedJJJrZFQIQyzIeBlw=";
  };

  patches = [
    # remove unused webkit
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/a4a3984465cb635822953350c571950ae726b539.patch";
      hash = "sha256-nHW18a4SrTG4fETJmKS4ojHXwnX1d1uN1m4H0GIuI28=";
    })
    # QtWebengine fixes
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/9ac73e7ad15de08aab6b1198115be2eb44da7afe.patch";
      hash = "sha256-qg2ytqA2On7jg19WZmHIOU7vLQI2hoyqItySLEA64SY=";
    })
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/commit/99a6d94bdfce9c4578cce82707e71863a71d1453.patch";
      hash = "sha256-o8JkaMmcJObmMt+o/6ooCAPCi+yRAWDAgxV+tR5eHfY=";
    })
    # Fix build on macOS
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/pull/35/commits/b68ed6fe72eaf9ee4e7e42925f5071fbd02dc6b3.patch";
      hash = "sha256-sJA0RE0Z83tYv0S42yQYWKKeLhW+YDsrxLkY5aMKKT4=";
    })
    (fetchpatch {
      url = "https://github.com/gyunaev/kchmviewer/pull/35/commits/d307e4e829c5a6f57ab0040f786c3da7fd2f0a99.patch";
      hash = "sha256-FWYfqG8heL6AnhevueCWHQc+c6Yj4+DuIdjIwXVZ+O4=";
    })
  ];

  buildInputs = [
    chmlib
    libzip
    qt5.qtwebengine
  ];

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/{Applications,bin}
        mv bin/kchmviewer.app $out/Applications
        ln -s $out/Applications/kchmviewer.app/Contents/MacOS/kchmviewer $out/bin/kchmviewer
      ''
    else
      ''
        install -Dm755 bin/kchmviewer -t $out/bin
        install -Dm644 packages/kchmviewer.png -t $out/share/pixmaps
        install -Dm644 packages/kchmviewer.desktop -t $out/share/applications
      '';

  meta = {
    description = "CHM (Winhelp) files viewer";
    mainProgram = "kchmviewer";
    homepage = "http://www.ulduzsoft.com/linux/kchmviewer/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
