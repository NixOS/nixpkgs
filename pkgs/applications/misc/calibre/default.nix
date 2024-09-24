{ lib
, stdenv
, fetchurl
, buildEnv
, cmake
, darwin
, fetchpatch
, fontconfig
, hunspell
, hyphen
, icu
, imagemagick
, libjpeg
, libmtp
, libpng
, libstemmer
, libuchardet
, libusb1
, pkg-config
, podofo
, poppler_utils
, python3Packages
, qmake
, qtbase
, qtwayland
, speechd-minimal
, sqlite
, wrapQtAppsHook
, xcbuild
, xdg-utils
, wrapGAppsHook3
, popplerSupport ? true
, speechSupport ? true
, unrarSupport ? false
, UserNotifications
}:

let
  sw = buildEnv {
    name = "calibre-dependencies";
    paths = [ hunspell libuchardet ];
    extraOutputsToInstall = [ "dev" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "7.16.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-EWQfaoTwO9BdZQgJQrxfj6b8tmtukvlW5hFo/USjNhU=";
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

    # On Darwin, use the Linux-style file layout instead of creating a macOS app
    # bundle.
    #
    # Here are the reasons:
    #
    # 1. To avoid bloating the closure size with bundled dependencies
    # 2. To avoid esoteric dependencies like the macOS framework build of Python
    # 3. For easier packaging. It would require non-trivial amount of effort to
    #    try to untangle the build script for macOS app bundles from upstream's
    #    unique build setup. It requires a macOS VM running on top of a Linux
    #    environment.
    #
    # The build script includes a check to prevent us doing what we want because
    # the two file layouts are incompatible with each other. So the following
    # patches remove that restriction from the build script and also removes
    # special handling for app bundles from the application code.
    ./lift-build-platform-restrictions.patch
    ./darwin-use-linux-layout.patch
  ] ++ lib.optionals (!unrarSupport) [
    ./dont_build_unrar_plugin.patch
  ];

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
    wrapGAppsHook3
    wrapQtAppsHook
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild # for plutils
    python3Packages.pyqt6
  ];

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
    libuchardet
    libusb1
    podofo
    poppler_utils
    qtbase
    sqlite
    (python3Packages.python.withPackages
      (ps: with ps; [
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
        zeroconf
        jeepney
        pycryptodome
        xxhash
        # the following are distributed with calibre, but we use upstream instead
        odfpy
      ] ++ lib.optionals (!stdenv.isDarwin) [
        # much of calibre's functionality is usable without a web
        # browser, so we enable building on platforms which qtwebengine
        # does not support by simply omitting qtwebengine.
        pyqt6-webengine
      ] ++ lib.optional (unrarSupport) unrardll)
    )
    xdg-utils
  ] ++ lib.optional (speechSupport) speechd-minimal
    ++ lib.optionals stdenv.isDarwin [
      UserNotifications
  ];

  installPhase = ''
    runHook preInstall

    export HOME=$TMPDIR/fakehome
  '' + lib.optionalString stdenv.isDarwin ''
    # some dependencies have to be placed under ~/sw on Darwin
    mkdir -p ~
    ln -s ${sw} ~/sw
  '' + ''
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

    ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py install \
      --root=$out \
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

  preFixup =
    let
      popplerArgs = "--prefix PATH : ${poppler_utils.out}/bin";
    in
    ''
      for program in $out/bin/*; do
        wrapProgram $program \
          ''${qtWrapperArgs[@]} \
          ''${gappsWrapperArgs[@]} \
          ${if popplerSupport then popplerArgs else ""}
      done
    '';

  doInstallCheck = true;
  installCheckInputs = with python3Packages; [
    fonttools
    psutil
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    ETN='--exclude-test-name'
    EXCLUDED_FLAGS=(
      $ETN 'test_7z'  # we don't include 7z support
      $ETN 'test_zstd'  # we don't include zstd support
      $ETN 'test_qt'  # we don't include svg or webp support
      $ETN 'test_import_of_all_python_modules'  # explores actual file paths, gets confused
      $ETN 'test_websocket_basic'  # flakey
      ${lib.optionalString (!unrarSupport) "$ETN 'test_unrar'"}
    )

    python setup.py test ''${EXCLUDED_FLAGS[@]}

    runHook postInstallCheck
  '';

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
    license = if unrarSupport
              then lib.licenses.unfreeRedistributable
              else lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
  };
})
