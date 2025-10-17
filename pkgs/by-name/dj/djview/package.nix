{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  djvulibre,
  libsForQt5,
  xorg,
  libtiff,
}:

stdenv.mkDerivation rec {
  pname = "djview";
  version = "4.12.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    hash = "sha256-F7+5cxq4Bw4BI1OB8I5XsSMf+19J6wMYc+v6GJza9H0=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    djvulibre
    libsForQt5.qtbase
    xorg.libXt
    libtiff
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--disable-silent-rules"
    "--disable-dependency-tracking"
    "--with-x"
    "--with-tiff"
    "--disable-nsdejavu" # 2023-11-14: modern browsers have dropped support for NPAPI
  ];

  postInstall =
    let
      Applications = "$out/Applications";
    in
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p ${Applications}
      cp -a src/djview.app -t ${Applications}

      mkdir -p $out/bin
      pushd $out/bin
      ln -sf ../Applications/djview.app/Contents/MacOS/djview
      popd
    '';

  meta = with lib; {
    description = "Portable DjVu viewer (Qt5)";
    mainProgram = "djview";
    homepage = "https://djvu.sourceforge.net/djview4.html";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      Anton-Latukha
      bryango
    ];
    longDescription = ''
      The portable DjVu viewer (Qt5) and browser (nsdejavu) plugin.

      Djview highlights:
        - entirely based on the public DjVulibre api.
        - entirely written in portable Qt5.
        - works natively under Unix/X11, MS Windows, and macOS X.
        - continuous scrolling of pages
        - side-by-side display of pages
        - ability to specify a url to the djview command
        - all plugin and cgi options available from the command line
        - all silly annotations implemented
        - display thumbnails as a grid
        - display outlines
        - page names supported (see djvused command set-page-title)
        - metadata dialog (see djvused command set-meta)
        - implemented as reusable Qt widgets

      nsdejavu: browser plugin for DjVu. It internally uses djview.
      Has CGI-style arguments to configure the view of document (see man).
    '';
  };
}
