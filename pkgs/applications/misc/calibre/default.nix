{ lib
, mkDerivation
, fetchurl
, poppler_utils
, pkg-config
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
, python3Packages
, libusb1
, libmtp
, xdg-utils
, removeReferencesTo
}:

mkDerivation rec {
  pname = "calibre";
  version = "5.16.1";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-lTXCW0MGNOezecaGO9c2JGU4ylwpPmBaMXTY3nLNcrE=";
  };

  patches = [
    # Plugin installation (very insecure) disabled (from Debian)
    ./disable_plugins.patch
    # Automatic version update disabled by default (from Debian)
    ./no_updates_dialog.patch
  ]
  ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  escaped_pyqt5_dir = builtins.replaceStrings ["/"] ["\\/"] (toString python3Packages.pyqt5);

  prePatch = ''
    sed -i "s/\[tool.sip.project\]/[tool.sip.project]\nsip-include-dirs = [\"${escaped_pyqt5_dir}\/share\/sip\/PyQt5\"]/g" \
      setup/build.py
    sed -i "s/\[tool.sip.bindings.pictureflow\]/[tool.sip.bindings.pictureflow]\ntags = [\"${python3Packages.sip_5.platform_tag}\"]/g" \
      setup/build.py

    # Remove unneeded files and libs
    rm -rf src/odf resources/calibre-portable.*
  '';

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [ pkg-config qmake removeReferencesTo ];

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
    xdg-utils
  ] ++ (
    with python3Packages; [
      apsw
      beautifulsoup4
      cchardet
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
      pyqt-builder
      pyqt5
      pyqtwebengine
      python
      regex
      sip_5
      zeroconf
      # the following are distributed with calibre, but we use upstream instead
      odfpy
    ] ++ lib.optional (unrarSupport) unrardll
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
    export SIP_BIN=${python3Packages.sip}/bin/sip
    export XDG_DATA_HOME=$out/share
    export XDG_UTILS_INSTALL_MODE="user"

    ${python3Packages.python.interpreter} setup.py install --root=$out \
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
      $out/lib/calibre/calibre/plugins/podofo.so

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
    homepage = "https://calibre-ebook.com";
    description = "Comprehensive e-book software";
    longDescription = ''
      calibre is a powerful and easy to use e-book manager. Users say it’s
      outstanding and a must-have. It’ll allow you to do nearly everything and
      it takes things a step beyond normal e-book software. It’s also completely
      free and open source and great for both casual users and computer experts.
    '';
    license = with licenses; if unrarSupport then unfreeRedistributable else gpl3Plus;
    maintainers = with maintainers; [ pSub AndersonTorres ];
    platforms = platforms.linux;
  };
}
