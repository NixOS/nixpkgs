{ lib
, mkDerivation
, fetchurl
, poppler_utils
, pkgconfig
, libpng
, imagemagick
, libjpeg
, fontconfig
, podofo
, qtbase
, qmake
, icu
, sqlite
, hunspell
, hyphen
, unrarSupport ? false
, chmlib
, pythonPackages
, libusb1
, libmtp
, xdg_utils
, makeDesktopItem
, removeReferencesTo
}:

mkDerivation rec {
  pname = "calibre";
  version = "4.23.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Ft5RRzzw4zb5RqVyUaHk9Pu6H4V/F9j8FKoTLn61lRg=";
  };

  patches = [
    # Patches from Debian that:
    # - disable plugin installation (very insecure)
    ./disable_plugins.patch
    # - switches the version update from enabled to disabled by default
    ./no_updates_dialog.patch
    # the unrar patch is not from debian
  ] ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "/pyqt_sip_dir/ s:=.*:= '${pythonPackages.pyqt5}/share/sip/PyQt5':"  \
      setup/build_environment.py

    # Remove unneeded files and libs
    rm -rf resources/calibre-portable.* \
           src/odf
  '';

  dontUseQmakeConfigure = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig qmake removeReferencesTo ];

  CALIBRE_PY3_PORT = builtins.toString pythonPackages.isPy3k;

  buildInputs = [
    chmlib
    fontconfig
    hunspell
    hyphen
    icu
    imagemagick
    libjpeg
    libmtp
    libpng
    libusb1
    podofo
    poppler_utils
    qtbase
    sqlite
    xdg_utils
  ] ++ (
    with pythonPackages; [
      apsw
      beautifulsoup4
      css-parser
      cssselect
      dateutil
      dnspython
      feedparser
      html2text
      html5-parser
      lxml
      markdown
      mechanize
      msgpack
      netifaces
      pillow
      pyqt5
      pyqtwebengine
      python
      regex
      sip
      # the following are distributed with calibre, but we use upstream instead
      odfpy
    ]
  );

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
    export SIP_BIN=${pythonPackages.sip}/bin/sip
    export XDG_DATA_HOME=$out/share
    export XDG_UTILS_INSTALL_MODE="user"

    ${pythonPackages.python.interpreter} setup.py install --root=$out \
      --prefix=$out \
      --libdir=$out/lib \
      --staging-root=$out \
      --staging-libdir=$out/lib \
      --staging-sharedir=$out/share

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    sed -i "2i import sys; sys.argv[0] = 'calibre'" $out/bin/calibre

    mkdir -p $out/share
    cp -a man-pages $out/share/man

    runHook postInstall
  '';

  # Wrap manually
  dontWrapQtApps = true;
  dontWrapGApps = true;

  # Remove some references to shrink the closure size. This reference (as of
  # 2018-11-06) was a single string like the following:
  #   /nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-podofo-0.9.6-dev/include/podofo/base/PdfVariant.h
  preFixup = ''
    remove-references-to -t ${podofo.dev} \
      $out/lib/calibre/calibre/plugins${lib.optionalString pythonPackages.isPy3k "/3"}/podofo.so

    for program in $out/bin/*; do
      wrapProgram $program \
        ''${qtWrapperArgs[@]} \
        ''${gappsWrapperArgs[@]} \
        --prefix PYTHONPATH : $PYTHONPATH \
        --prefix PATH : ${poppler_utils.out}/bin
    done
  '';

  disallowedReferences = [ podofo.dev ];

  meta = with lib; {
    description = "Comprehensive e-book software";
    homepage = "https://calibre-ebook.com";
    license = with licenses; if unrarSupport then unfreeRedistributable else gpl3;
    maintainers = with maintainers; [ domenkozar pSub AndersonTorres ];
    platforms = platforms.linux;
    inherit version;
  };
}
