{ stdenv, fetchurl, python, pyqt5, sip, poppler_utils, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qtbase, qmakeHook, icu, sqlite
, makeWrapper, unrarSupport ? false, chmlib, pythonPackages, xz, libusb1, libmtp
, xdg_utils, makeDesktopItem
}:

stdenv.mkDerivation rec {
  version = "2.64.0";
  name = "calibre-${version}";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${name}.tar.xz";
    sha256 = "0jjbkhd3n7rh5q6cl6yy51hyjbxmgm6xj7i2a1d3h2ggrip1zmr9";
  };

  inherit python;

  patches = [
    # Patch from Debian that switches the version update change from
    # enabled by default to disabled by default.
    ./no_updates_dialog.patch
  ] ++ stdenv.lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "/pyqt_sip_dir/ s:=.*:= '${pyqt5}/share/sip/PyQt5':"  \
      setup/build_environment.py
  '';

  dontUseQmakeConfigure = true;
  # hack around a build problem
  preBuild = ''
    mkdir -p ../tmp.*/lib
  '';

  nativeBuildInputs = [ makeWrapper pkgconfig qmakeHook ];

  buildInputs =
    [ python pyqt5 sip poppler_utils libpng imagemagick libjpeg
      fontconfig podofo qtbase chmlib icu sqlite libusb1 libmtp xdg_utils
      pythonPackages.mechanize pythonPackages.lxml pythonPackages.dateutil
      pythonPackages.cssutils pythonPackages.beautifulsoup pythonPackages.pillow
      pythonPackages.sqlite3 pythonPackages.netifaces pythonPackages.apsw
      pythonPackages.cssselect
    ];

  installPhase = ''
    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${poppler_utils.dev}/include/poppler
    export POPPLER_LIB_DIR=${poppler_utils.out}/lib
    export MAGICK_INC=${imagemagick.dev}/include/ImageMagick
    export MAGICK_LIB=${imagemagick.out}/lib
    export FC_INC_DIR=${fontconfig.dev}/include/fontconfig
    export FC_LIB_DIR=${fontconfig.lib}/lib
    export PODOFO_INC_DIR=${podofo}/include/podofo
    export PODOFO_LIB_DIR=${podofo}/lib
    export SIP_BIN=${sip}/bin/sip
    python setup.py install --prefix=$out

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    sed -i "2i import sys; sys.argv[0] = 'calibre'" $out/bin/calibre

    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH \
                     --prefix PATH : ${poppler_utils.out}/bin
    done

    # Replace @out@ by the output path.
    mkdir -p $out/share/applications/
    cp {$calibreDesktopItem,$ebookEditDesktopItem,$ebookViewerDesktopItem}/share/applications/* $out/share/applications/
    for entry in $out/share/applications/*.desktop; do
      substituteAllInPlace $entry
    done
  '';

  calibreDesktopItem = makeDesktopItem {
    name = "calibre";
    desktopName = "calibre";
    exec = "@out@/bin/calibre --detach %F";
    genericName = "E-book library management";
    icon = "@out@/share/calibre/images/library.png";
    comment = "Manage, convert, edit, and read e-books";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "application/x-mobipocket-subscription"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "text/html"
      "application/x-cbc"
      "application/ereader"
      "application/oebps-package+xml"
      "image/vnd.djvu"
      "application/x-sony-bbeb"
      "application/vnd.ms-word.document.macroenabled.12"
      "text/rtf"
      "text/x-markdown"
      "application/pdf"
      "application/x-cbz"
      "application/x-mobipocket-ebook"
      "application/x-cbr"
      "application/x-mobi8-ebook"
      "text/fb2+xml"
      "application/vnd.oasis.opendocument.text"
      "application/epub+zip"
      "text/plain"
      "application/xhtml+xml"
    ];
    categories = "Office";
    extraEntries = ''
      Actions=ebook-edit ebook-viewer

      [Desktop Action ebook-edit]
      Name=Edit E-book
      Icon=@out@/share/calibre/images/tweak.png
      Exec=@out@/bin/ebook-edit --detach %F

      [Desktop Action ebook-viewer]
      Name=E-book Viewer
      Icon=@out@/share/calibre/images/viewer.png
      Exec=@out@/bin/ebook-viewer --detach %F
    '';
  };

  ebookEditDesktopItem = makeDesktopItem {
    name = "calibre-edit-ebook";
    desktopName = "Edit E-book";
    genericName = "E-book Editor";
    comment = "Edit e-books";
    icon = "@out@/share/calibre/images/tweak.png";
    exec = "@out@/bin/ebook-edit --detach %F";
    categories = "Office;Publishing";
    mimeType = "application/epub+zip";
    extraEntries = "NoDisplay=true";
  };

  ebookViewerDesktopItem = makeDesktopItem {
    name = "calibre-ebook-viewer";
    desktopName = "E-book Viewer";
    genericName = "E-book Viewer";
    comment = "Read e-books in all the major formats";
    icon = "@out@/share/calibre/images/viewer.png";
    exec = "@out@/bin/ebook-viewer --detach %F";
    categories = "Office;Viewer";
    mimeType = "application/epub+zip";
    extraEntries = "NoDisplay=true";
  };

  meta = with stdenv.lib; {
    description = "Comprehensive e-book software";
    homepage = https://calibre-ebook.com;
    license = with licenses; if unrarSupport then unfreeRedistributable else gpl3;
    maintainers = with maintainers; [ viric domenkozar pSub AndersonTorres ];
    platforms = platforms.linux;
    inherit version;
  };
}
