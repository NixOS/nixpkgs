{ stdenv, fetchurl, poppler_utils, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qtbase, qmake, icu, sqlite
, makeWrapper, unrarSupport ? false, chmlib, python2Packages, libusb1, libmtp
, xdg_utils, makeDesktopItem, wrapGAppsHook, removeReferencesTo
}:

stdenv.mkDerivation rec {
  version = "3.37.0";
  name = "calibre-${version}";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${name}.tar.xz";
    sha256 = "12si7jag5ildy08h0nfs4rfpn417i82valxbk2wjkypp226gqi05";
  };

  patches = [
    # Patches from Debian that:
    # - disable plugin installation (very insecure)
    ./disable_plugins.patch
    # - switches the version update from enabled to disabled by default
    ./no_updates_dialog.patch
    # the unrar patch is not from debian
  ] ++ stdenv.lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "/pyqt_sip_dir/ s:=.*:= '${python2Packages.pyqt5_with_qtwebkit}/share/sip/PyQt5':"  \
      setup/build_environment.py

    # Remove unneeded files and libs
    rm -rf resources/calibre-portable.* \
           src/odf
  '';

  dontUseQmakeConfigure = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper pkgconfig qmake removeReferencesTo ];

  buildInputs = [
    poppler_utils libpng imagemagick libjpeg
    fontconfig podofo qtbase chmlib icu sqlite libusb1 libmtp xdg_utils wrapGAppsHook
  ] ++ (with python2Packages; [
    apsw cssselect css-parser dateutil dnspython html5-parser lxml mechanize netifaces pillow
    python pyqt5_with_qtwebkit sip
    regex msgpack
    # the following are distributed with calibre, but we use upstream instead
    odfpy
  ]);

  installPhase = ''
    runHook preInstall

    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${poppler_utils.dev}/include/poppler
    export POPPLER_LIB_DIR=${poppler_utils.out}/lib
    export MAGICK_INC=${imagemagick.dev}/include/ImageMagick
    export MAGICK_LIB=${imagemagick.out}/lib
    export FC_INC_DIR=${fontconfig.dev}/include/fontconfig
    export FC_LIB_DIR=${fontconfig.lib}/lib
    export PODOFO_INC_DIR=${podofo.dev}/include/podofo
    export PODOFO_LIB_DIR=${podofo.lib}/lib
    export SIP_BIN=${python2Packages.sip}/bin/sip
    ${python2Packages.python.interpreter} setup.py install --prefix=$out

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

    mkdir -p $out/share
    cp -a man-pages $out/share/man

    runHook postInstall
  '';

  # Remove some references to shrink the closure size. This reference (as of
  # 2018-11-06) was a single string like the following:
  #   /nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-podofo-0.9.6-dev/include/podofo/base/PdfVariant.h
  preFixup = ''
    remove-references-to -t ${podofo.dev} $out/lib/calibre/calibre/plugins/podofo.so
  '';

  disallowedReferences = [ podofo.dev ];

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
      Actions=Edit;Viewer;

      [Desktop Action Edit]
      Name=Edit E-book
      Icon=@out@/share/calibre/images/tweak.png
      Exec=@out@/bin/ebook-edit --detach %F

      [Desktop Action Viewer]
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
    maintainers = with maintainers; [ domenkozar pSub AndersonTorres ];
    platforms = platforms.linux;
    inherit version;
  };
}
