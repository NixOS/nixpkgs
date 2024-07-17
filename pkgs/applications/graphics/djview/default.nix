{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  pkg-config,
  djvulibre,
  qtbase,
  qttools,
  xorg,
  libtiff,
  darwin,
}:

mkDerivation rec {
  pname = "djview";
  version = "4.10.6";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    sha256 = "08bwv8ppdzhryfcnifgzgdilb12jcnivl4ig6hd44f12d76z6il4";
  };

  nativeBuildInputs = [
    pkg-config
    qttools
  ];

  buildInputs = [
    djvulibre
    qtbase
    xorg.libXt
    libtiff
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.AGL;

  configureFlags = [
    "--disable-silent-rules"
    "--disable-dependency-tracking"
    "--with-x"
    "--with-tiff"
    # NOTE: 2019-09-19: experimental "--enable-npdjvu" fails
  ] ++ lib.optional stdenv.isDarwin "--enable-mac";

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A portable DjVu viewer (Qt5) and browser (nsdejavu) plugin";
    mainProgram = "djview";
    homepage = "https://djvu.sourceforge.net/djview4.html";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Anton-Latukha ];
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
