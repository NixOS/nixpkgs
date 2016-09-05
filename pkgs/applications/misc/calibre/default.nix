{ stdenv, fetchurl, fetchpatch, python, pyqt5, sip, poppler_utils, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qtbase, qmakeHook, icu, sqlite
, makeWrapper, unrarSupport ? false, chmlib, pythonPackages, xz, libusb1, libmtp
, xdg_utils, makeDesktopItem
}:

stdenv.mkDerivation rec {
  version = "2.66.0";
  name = "calibre-${version}";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${name}.tar.xz";
    sha256 = "1dbv6p9cq9zj51zvhfy2b7aic2zqa44lmfmq7k7fkqcgb6wmanic";
  };

  inherit python;

  patches = [
    # Patches from Debian that:
    # - disable plugin installation (very insecure)
    # - disables loading of web bug for privacy
    # - switches the version update from enabled to disabled by default
    (fetchpatch {
      name = "disable_plugins.patch";
      url = "http://bazaar.launchpad.net/~calibre-packagers/calibre/debian/download/head:/disable_plugins.py-20111220183043-dcl08ccfagjxt1dv-1/disable_plugins.py";
      sha256 = "19spdx52dhbrfn9lm084yl3cfwm6f90imd51k97sf7flmpl569pk";
    })
    (fetchpatch {
      name = "links_privacy.patch";
      url = "http://bazaar.launchpad.net/~calibre-packagers/calibre/debian/download/head:/linksprivacy.patch-20160417214308-6hvive72pc0r4awc-1/links-privacy.patch";
      sha256 = "0f6pq2b7q56pxrq2j8yqd7bksc623q2zgq29qcli30f13vga1w60";
    })
    (fetchpatch {
      name = "no_updates_dialog.patch";
      url = "http://bazaar.launchpad.net/~calibre-packagers/calibre/debian/download/head:/no_updates_dialog.pa-20081231120426-rzzufl0zo66t3mtc-16/no_updates_dialog.patch";
      sha256 = "16xwa2fa47jvs954fjrwr8rhh89aljgi1d1wrfxa40sknlmfwxif";
    })
    # the unrar patch is not from debian
  ] ++ stdenv.lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "/pyqt_sip_dir/ s:=.*:= '${pyqt5}/share/sip/PyQt5':"  \
      setup/build_environment.py

    # Remove unneeded files and libs
    rm -rf resources/calibre-portable.* \
           src/{chardet,cherrypy,html5lib,odf,routes}
  '';

  dontUseQmakeConfigure = true;
  # hack around a build problem
  preBuild = ''
    mkdir -p ../tmp.*/lib
  '';

  nativeBuildInputs = [ makeWrapper pkgconfig qmakeHook ];

  buildInputs = [
    python pyqt5 sip poppler_utils libpng imagemagick libjpeg
    fontconfig podofo qtbase chmlib icu sqlite libusb1 libmtp xdg_utils
  ] ++ (with pythonPackages; [
    apsw beautifulsoup cssselect cssutils dateutil lxml mechanize netifaces pillow sqlite3
    # the following are distributed with calibre, but we use upstream instead
    chardet cherrypy html5lib odfpy routes
  ]);

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
