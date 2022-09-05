{ lib
, mkDerivation
, fetchurl
, fetchpatch
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
, python3Packages
, libusb1
, libmtp
, xdg-utils
, removeReferencesTo
, libstemmer
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "calibre";
  version = "5.42.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-pob9GZl3Wiky5aMGGvcNQdDrKh19bo+n5ihdS45X+Vg=";
  };

  # https://sources.debian.org/patches/calibre/${version}+dfsg-1
  patches = [
    #  allow for plugin update check, but no calibre version check
    (fetchpatch {
      name = "0001-only-plugin-update.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${version}%2Bdfsg-1/debian/patches/0001-only-plugin-update.patch";
      sha256 = "sha256:1h2hl4z9qm17crms4d1lq2cq44cnxbga1dv6qckhxvcg6pawxg3l";
    })
    (fetchpatch {
      name = "0007-Hardening-Qt-code.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${version}%2Bdfsg-1/debian/patches/0007-Hardening-Qt-code.patch";
      sha256 = "sha256:18wps7fn0cpzb7gf78f15pmbaff4vlygc9g00hq7zynfa4pcgfdg";
    })
  ]
  ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "s@\[tool.sip.project\]@[tool.sip.project]\nsip-include-dirs = [\"${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings\"]@g" \
      setup/build.py
    sed -i "s/\[tool.sip.bindings.pictureflow\]/[tool.sip.bindings.pictureflow]\ntags = [\"${python3Packages.sip.platform_tag}\"]/g" \
      setup/build.py

    # Remove unneeded files and libs
    rm -rf src/odf resources/calibre-portable.*
  '';

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [ pkg-config qmake removeReferencesTo wrapGAppsHook ];

  buildInputs = [
    fontconfig
    hunspell
    hyphen
    icu
    imagemagick
    libjpeg
    libmtp
    libpng
    libstemmer
    libusb1
    podofo
    poppler_utils
    qtbase
    sqlite
    xdg-utils
  ] ++ (
    with python3Packages; [
      (apsw.overrideAttrs (oldAttrs: rec {
        setupPyBuildFlags = [ "--enable=load_extension" ];
      }))
      beautifulsoup4
      cchardet
      css-parser
      cssselect
      python-dateutil
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
      pychm
      pyqt-builder
      pyqt5
      python
      regex
      sip
      setuptools
      zeroconf
      jeepney
      pycryptodome
      # the following are distributed with calibre, but we use upstream instead
      odfpy
    ] ++ lib.optionals (lib.lists.any (p: p == stdenv.hostPlatform.system) pyqtwebengine.meta.platforms) [
      # much of calibre's functionality is usable without a web
      # browser, so we enable building on platforms which qtwebengine
      # does not support by simply omitting qtwebengine.
      pyqtwebengine
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

  # Remove some references to shrink the closure size. This reference (as of
  # 2018-11-06) was a single string like the following:
  #   /nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-podofo-0.9.6-dev/include/podofo/base/PdfVariant.h
  preFixup = ''
    remove-references-to -t ${podofo.dev} \
      $out/lib/calibre/calibre/plugins/podofo.so

    for program in $out/bin/*; do
      wrapProgram $program \
        ''${qtWrapperArgs[@]} \
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
