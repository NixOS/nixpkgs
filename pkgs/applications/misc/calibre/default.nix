{
  lib,
  stdenv,
  fetchurl,
  cmake,
  fetchpatch,
  fontconfig,
  hunspell,
  hyphen,
  icu,
  imagemagick,
  libjpeg,
  libmtp,
  libpng,
  libstemmer,
  libuchardet,
  libusb1,
  pkg-config,
  podofo,
  poppler_utils,
  python3Packages,
  qmake,
  qtbase,
  qtwayland,
  removeReferencesTo,
  speechd,
  sqlite,
  wrapQtAppsHook,
  xdg-utils,
  wrapGAppsHook3,
  unrarSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "7.10.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-GvvvoqLBzapveKFSqlED471pUyRjLoYqU5YjN/L/nEs=";
  };

  patches = [
    #  allow for plugin update check, but no calibre version check
    (fetchpatch {
      name = "0001-only-plugin-update.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${finalAttrs.version}+ds-1/debian/patches/0001-only-plugin-update.patch";
      hash = "sha256-mHZkUoVcoVi9XBOSvM5jyvpOTCcM91g9+Pa/lY6L5p8=";
    })
    (fetchpatch {
      name = "0007-Hardening-Qt-code.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${finalAttrs.version}+ds-1/debian/patches/hardening/0007-Hardening-Qt-code.patch";
      hash = "sha256-a6yyG0RUsQJBBNxeJsTtQSBV2lxdzz1hnTob88O+SKg=";
    })
    (fetchpatch {
      name = "CVE-2024-6781.patch";
      url = "https://github.com/kovidgoyal/calibre/commit/bcd0ab12c41a887f8290a9b56e46c3a29038d9c4.patch";
      hash = "sha256-HZdbkKZYGYJ5pjv0ZNFNyT0gkeNPcMXKLEYGr6uzGAw=";
    })
    (fetchpatch {
      name = "CVE-2024-6782.patch";
      url = "https://github.com/kovidgoyal/calibre/commit/38a1bf50d8cd22052ae59c513816706c6445d5e9.patch";
      hash = "sha256-0E5RdzXAwenV15BqSHJxRTh3Ay8Vh1Z9AloqCHHrB50=";
    })
    (fetchpatch {
      name = "CVE-2024-7008.patch";
      url = "https://github.com/kovidgoyal/calibre/commit/863abac24e7bc3e5ca0b3307362ff1953ba53fe0.patch";
      hash = "sha256-0dV34AJRwQYE02bDdnA4o/fsy1q4vR7H5krBHyeAeKY=";
    })
    (fetchpatch {
      name = "CVE-2024-7009.patch";
      url = "https://github.com/kovidgoyal/calibre/commit/d56574285e8859d3d715eb7829784ee74337b7d7.patch";
      hash = "sha256-LFi68mIweF/2C/YNSrUiLwrq4++GSWxTmgVK1ktf3V4=";
    })
  ] ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

  prePatch = ''
    sed -i "s@\[tool.sip.project\]@[tool.sip.project]\nsip-include-dirs = [\"${python3Packages.pyqt6}/${python3Packages.python.sitePackages}/PyQt6/bindings\"]@g" \
      setup/build.py

    # Remove unneeded files and libs
    rm -rf src/odf resources/calibre-portable.*
  '';

  dontUseQmakeConfigure = true;
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qmake
    removeReferencesTo
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs =
    [
      fontconfig
      hunspell
      hyphen
      icu
      imagemagick
      libjpeg
      libmtp
      libpng
      libstemmer
      libuchardet
      libusb1
      podofo
      poppler_utils
      qtbase
      qtwayland
      sqlite
      xdg-utils
    ]
    ++ (
      with python3Packages;
      [
        (apsw.overrideAttrs (oldAttrs: {
          setupPyBuildFlags = [ "--enable=load_extension" ];
        }))
        beautifulsoup4
        css-parser
        cssselect
        python-dateutil
        dnspython
        faust-cchardet
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
        pyqt6
        python
        regex
        sip
        setuptools
        speechd
        zeroconf
        jeepney
        pycryptodome
        xxhash
        # the following are distributed with calibre, but we use upstream instead
        odfpy
      ]
      ++
        lib.optionals (lib.lists.any (p: p == stdenv.hostPlatform.system) pyqt6-webengine.meta.platforms)
          [
            # much of calibre's functionality is usable without a web
            # browser, so we enable building on platforms which qtwebengine
            # does not support by simply omitting qtwebengine.
            pyqt6-webengine
          ]
      ++ lib.optional (unrarSupport) unrardll
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

    ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py install --root=$out \
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

  meta = {
    homepage = "https://calibre-ebook.com";
    description = "Comprehensive e-book software";
    longDescription = ''
      calibre is a powerful and easy to use e-book manager. Users say it’s
      outstanding and a must-have. It’ll allow you to do nearly everything and
      it takes things a step beyond normal e-book software. It’s also completely
      free and open source and great for both casual users and computer experts.
    '';
    changelog = "https://github.com/kovidgoyal/calibre/releases/tag/v${finalAttrs.version}";
    license = if unrarSupport then lib.licenses.unfreeRedistributable else lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
