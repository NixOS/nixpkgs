{
  lib,
  stdenv,
  fetchurl,
  cmake,
  espeak-ng,
  fetchpatch,
  ffmpeg,
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
  libwebp,
  nix-update-script,
  onnxruntime,
  optipng,
  piper-tts,
  pkg-config,
  podofo0,
  poppler-utils,
  python314Packages,
  qt6,
  speechd-minimal,
  sqlite,
  versionCheckHook,
  xdg-utils,
  wrapGAppsHook3,
  popplerSupport ? true,
  speechSupport ? true,
  unrarSupport ? false,
}:
let
  python3Packages = python314Packages; # Calibre 9.0+ requires python3.14+
in
stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "9.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-ONfYjXq8vGLG/jV1SD+1STzpYtJhqXihpNtNWLxLN5M=";
  };

  patches =
    let
      debian-source = "ds+_0.10.6-1";
      debian-tag = "${finalAttrs.version}+${debian-source}";
    in
    [
      #  allow for plugin update check, but no calibre version check
      (fetchpatch {
        name = "0001-only-plugin-update-${debian-tag}.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${debian-tag}/debian/patches/0001-only-plugin-update.patch";
        hash = "sha256-2QhNf9CBxvoMiK9ZqBWnA/zdcIYpY+HGG0uguUZbinw=";
      })
      (fetchpatch {
        name = "0007-Hardening-Qt-code-${debian-tag}.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${debian-tag}/debian/patches/hardening/0007-Hardening-Qt-code.patch";
        hash = "sha256-ItJalYmBhK4Qgz6QDGbPpBMaa6oGQetQvg5ie3oxFMM=";
      })
    ];

  postPatch =
    lib.optionalString (!unrarSupport)
      # Don't build the unrar plugin
      ''
        substituteInPlace src/calibre/ebooks/metadata/archive.py \
          --replace-fail \
            "file_types = {'zip', 'rar', '7z'}" \
            "file_types = {'zip', '7z'}"
      '';

  prePatch = ''
    sed -i "s@\[tool.sip.project\]@[tool.sip.project]\nsip-include-dirs = [\"${python3Packages.pyqt6}/${python3Packages.python.sitePackages}/PyQt6/bindings\"]@g" \
      setup/build.py

    # Remove unneeded files and libs
    rm -rf src/odf resources/calibre-portable.*
  '';

  dontUseQmakeConfigure = true;
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    # `pdftotext`/`pdftohtml` are run by the test suite
    poppler-utils
    python3Packages.python
    qt6.qmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
    # `xdg-icon-resource` & co. are run by the desktop integration setup in `installPhase`
    xdg-utils
  ];

  buildInputs = [
    espeak-ng
    ffmpeg
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
    onnxruntime
    podofo0
    poppler-utils
    qt6.qtbase
    qt6.qtwayland
    sqlite
    (python3Packages.python.withPackages (
      ps:
      with ps;
      [
        (apsw.overrideAttrs (_oldAttrs: {
          setupPyBuildFlags = [ "--enable=load_extension" ];
        }))
        beautifulsoup4
        css-parser
        cssselect
        fonttools
        python-dateutil
        dnspython
        faust-cchardet
        feedparser
        feedparser-sgmllib
        html2text
        html5-parser
        lxml
        markdown
        mechanize
        msgpack
        netifaces
        pillow
        pychm
        pykakasi
        pyqt-builder
        pyqt6
        pystache
        python
        regex
        sip
        setuptools
        tzdata
        tzlocal
        zeroconf
        jeepney
        pycryptodome
        xxhash
        # the following are distributed with calibre, but we use upstream instead
        odfpy
      ]
      ++ lib.optionals (lib.lists.elem stdenv.hostPlatform.system pyqt6-webengine.meta.platforms) [
        # much of calibre's functionality is usable without a web
        # browser, so we enable building on platforms which qtwebengine
        # does not support by simply omitting qtwebengine.
        pyqt6-webengine
      ]
      ++ lib.optional unrarSupport unrardll
    ))
    xdg-utils
  ]
  ++ lib.optionals speechSupport [
    piper-tts
    (speechd-minimal.override { inherit python3Packages; })
  ];

  env = {
    HOME = "/tmp";
    MAGICK_INC = "${lib.getDev imagemagick}/include/ImageMagick";
    MAGICK_LIB = "${lib.getLib imagemagick}/lib";
    FC_INC_DIR = "${lib.getDev fontconfig}/include/fontconfig";
    FC_LIB_DIR = "${lib.getLib fontconfig}/lib";
    PODOFO_INC_DIR = "${lib.getDev podofo0}/include/podofo";
    PODOFO_LIB_DIR = "${lib.getLib podofo0}/lib";
    XDG_DATA_HOME = "${placeholder "out"}/share";
    XDG_UTILS_INSTALL_MODE = "user";
  }
  // lib.optionalAttrs popplerSupport {
    POPPLER_INC_DIR = "${lib.getDev poppler-utils}/include/poppler";
    POPPLER_LIB_DIR = "${lib.getLib poppler-utils}/lib";
  }
  // lib.optionalAttrs speechSupport {
    PIPER_TTS_DIR = "${lib.getBin piper-tts}/bin";
  };

  installPhase = ''
    runHook preInstall

    python setup.py install --root=$out \
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
      popplerArgs = "--prefix PATH : ${poppler-utils.out}/bin";
    in
    ''
      for program in $out/bin/*; do
        wrapProgram $program \
          ''${qtWrapperArgs[@]} \
          ''${gappsWrapperArgs[@]} \
          --set QTWEBENGINE_CHROMIUM_FLAGS "--disable-gpu" \
          --prefix PATH : ${
            lib.makeBinPath [
              libjpeg
              libwebp
              optipng
            ]
          } \
          ${lib.optionalString popplerSupport popplerArgs}
      done
    '';

  doInstallCheck = true;
  installCheckInputs = with python3Packages; [
    psutil
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  # `calibre --version` drops a trailing `.0`, so check against a binary reporting the full version
  versionCheckProgram = "${placeholder "out"}/bin/ebook-convert";
  installCheckPhase =
    let
      excludedTestNames = [
        "test_7z" # we don't include 7z support
        "test_zstd" # we don't include zstd support
        "test_qt" # we don't include svg or webp support
        "test_import_of_all_python_modules" # explores actual file paths, gets confused
        "test_websocket_basic" # flaky

        # Flaky: asserts on page-granularity RSS deltas, which are 0 (assertion skipped)
        # on most runs and allocator noise otherwise
        "test_mem_leaks"

        # hangs with cuda enabled, also:
        # eglInitialize: Failed to get system egl display
        # Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
        "test_recipe_browser_webengine"
        # Flaky test, occasionally errors with python exception:
        # urllib.error.URLError: <urlopen error NetworkError.RemoteHostClosedError: Connection closed>
        "test_recipe_browser_qt"
      ]
      ++ lib.optionals stdenv.hostPlatform.isAarch64 [
        # https://github.com/microsoft/onnxruntime/issues/10038
        "test_piper"

        # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
        #  what():  /build/source/include/onnxruntime/core/common/logging/logging.h:371
        # static const onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger()
        # Attempt to use DefaultLogger but none has been registered.
        "test_plugins"
      ]
      ++ lib.optionals (!speechSupport) [
        "test_speech_dispatcher"
      ]
      ++ lib.optionals (!unrarSupport) [
        "test_unrar"
      ];

      testFlags = lib.concatStringsSep " " (
        lib.map (testName: "--exclude-test-name ${testName}") excludedTestNames
      );
    in
    ''
      runHook preInstallCheck

      python setup.py test ${testFlags}

      runHook postInstallCheck
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://github.com/kovidgoyal/calibre" ];
  };

  meta = {
    homepage = "https://calibre-ebook.com";
    description = "Comprehensive e-book software";
    mainProgram = "calibre";
    longDescription = ''
      calibre is a powerful and easy to use e-book manager. Users say it’s
      outstanding and a must-have. It’ll allow you to do nearly everything and
      it takes things a step beyond normal e-book software. It’s also completely
      free and open source and great for both casual users and computer experts.
    '';
    changelog = "https://github.com/kovidgoyal/calibre/releases/tag/v${finalAttrs.version}";
    license = if unrarSupport then lib.licenses.unfreeRedistributable else lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      pSub
      sempiternal-aurora
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
