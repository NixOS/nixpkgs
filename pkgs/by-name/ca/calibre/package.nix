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
  podofo_0_10,
  poppler-utils,
  python3Packages,
  qt6,
  speechd-minimal,
  sqlite,
  xdg-utils,
  wrapGAppsHook3,
  popplerSupport ? true,
  speechSupport ? true,
  unrarSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "8.12.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZY7FXpJCWJ3495SPW3Px/oNt5CkffMzmCb8Qt12dluw=";
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
      hash = "sha256-V/ZUTH0l4QSfM0dHrgLGdJjF/CCQ0S/fnCP/ZKD563U=";
    })
  ]
  ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;

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
    qt6.qmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
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
    podofo_0_10
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
      ]
      ++
        lib.optionals (lib.lists.any (p: p == stdenv.hostPlatform.system) pyqt6-webengine.meta.platforms)
          [
            # much of calibre's functionality is usable without a web
            # browser, so we enable building on platforms which qtwebengine
            # does not support by simply omitting qtwebengine.
            pyqt6-webengine
          ]
      ++ lib.optional unrarSupport unrardll
    ))
    piper-tts
    xdg-utils
  ]
  ++ lib.optional speechSupport speechd-minimal;

  installPhase = ''
    runHook preInstall

    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${poppler-utils.dev}/include/poppler
    export POPPLER_LIB_DIR=${poppler-utils.out}/lib
    export MAGICK_INC=${imagemagick.dev}/include/ImageMagick
    export MAGICK_LIB=${imagemagick.out}/lib
    export FC_INC_DIR=${fontconfig.dev}/include/fontconfig
    export FC_LIB_DIR=${fontconfig.lib}/lib
    export PODOFO_INC_DIR=${podofo_0_10.dev}/include/podofo
    export PODOFO_LIB_DIR=${podofo_0_10}/lib
    export XDG_DATA_HOME=$out/share
    export XDG_UTILS_INSTALL_MODE="user"
    export PIPER_TTS_DIR=${piper-tts}/bin

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
          --prefix PATH : ${
            lib.makeBinPath [
              libjpeg
              libwebp
              optipng
            ]
          } \
          ${if popplerSupport then popplerArgs else ""}
      done
    '';

  doInstallCheck = true;
  installCheckInputs = with python3Packages; [
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
      # hangs with cuda enabled, also:
      # eglInitialize: Failed to get system egl display
      # Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
      $ETN 'test_recipe_browser_webengine'

      ${lib.optionalString stdenv.hostPlatform.isAarch64 "$ETN 'test_piper'"} # https://github.com/microsoft/onnxruntime/issues/10038
      ${lib.optionalString (!unrarSupport) "$ETN 'test_unrar'"}
    )

    python setup.py test ''${EXCLUDED_FLAGS[@]}

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://github.com/kovidgoyal/calibre" ];
  };

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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
