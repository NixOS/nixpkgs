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
  version = "8.14.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-97kkjzjbrdmiWpNaz9nSt6BbgVvczsxunLrKVJvqxVQ=";
  };

  patches =
    let
      debian-source = "ds+_0.10.5-1";
    in
    [
      #  allow for plugin update check, but no calibre version check
      (fetchpatch {
        name = "0001-only-plugin-update.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${finalAttrs.version}+${debian-source}/debian/patches/0001-only-plugin-update.patch";
        hash = "sha256-mHZkUoVcoVi9XBOSvM5jyvpOTCcM91g9+Pa/lY6L5p8=";
      })
      (fetchpatch {
        name = "0007-Hardening-Qt-code.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${finalAttrs.version}+${debian-source}/debian/patches/hardening/0007-Hardening-Qt-code.patch";
        hash = "sha256-lKp/omNicSBiQUIK+6OOc8ysM6LImn5GxWhpXr4iX+U=";
      })
      # Fix CVE-2026-25635
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0156
      # https://github.com/NixOS/nixpkgs/issues/488046
      # Fixed upstream in 9.2.0.
      (fetchpatch {
        name = "CVE-2026-25635.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/9739232fcb029ac15dfe52ccd4fdb4a07ebb6ce9.patch";
        hash = "sha256-fzotxhfMF/DCMvpIfMSOGY8iVOybsYymRQvhXf7jQyc=";
      })
      # Fix CVE-2026-25636
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0160
      # https://github.com/NixOS/nixpkgs/issues/488052
      # Fixed upstream in 9.1.0.
      #
      # Both patches appear to be needed to fix the CVE.
      (fetchpatch {
        name = "CVE-2026-25636.1.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/267bfd34020a4f297c2de9cc0cde50ebe5d024d4.patch";
        hash = "sha256-5CKlJG0e0v/VXiIeAqiByThRgMs+gwRdgOzPHupB8A8=";
      })
      (fetchpatch {
        name = "CVE-2026-25636.2.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/9484ea82c6ab226c18e6ca5aa000fa16de598726.patch";
        hash = "sha256-hpWFSQXyOAVRqou0v+5oT5zIrBbyP2Uv2z1Vg811ZG0=";
      })
      # Fix CVE-2026-25731
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0155
      # https://github.com/NixOS/nixpkgs/issues/488045
      # Fixed upstream in 9.2.0.
      #
      # Manually ported to the current release version from the patch:
      # https://github.com/kovidgoyal/calibre/commit/f0649b27512e987b95fcab2e1e0a3bcdafc23379.patch
      ./CVE-2026-25731.patch
      # Fix CVE-2026-26064
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0326
      # https://github.com/NixOS/nixpkgs/issues/494339
      # Fixed upstream in 9.3.0.
      (fetchpatch {
        name = "CVE-2026-26064.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/e1b5f9b45a5e8fa96c136963ad9a1d35e6adac62.patch";
        hash = "sha256-C7DBSuaL5VpLbjh/jMar+QdoqaobKcpEWJIIbpxMwjE=";
      })
      # Fix CVE-2026-26065
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0327
      # https://github.com/NixOS/nixpkgs/issues/494340
      # Fixed upstream in 9.3.0.
      (fetchpatch {
        name = "CVE-2026-26065.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/b6da1c3878c06eb1356cb0ec1106cb66e0e9bfb8.patch";
        hash = "sha256-zYC2A5qNsCWycygnD+SjtgSE5kclWXIe/etfZAL3Mek=";
      })
      # Fix CVE-2026-27810
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0485
      # https://github.com/NixOS/nixpkgs/issues/495148
      # Fixed upstream in 9.4.0.
      (fetchpatch {
        name = "CVE-2026-27810.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/a468ce0f268032eea1f7431853248148ffa2e06a.patch";
        hash = "sha256-98htxrV0Wc2UmZOgEjoj6JDWmUbvS0GoC7svUhv4+ns=";
      })
      # Fix CVE-2026-27824
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0504
      # https://github.com/NixOS/nixpkgs/issues/496127
      # Fixed upstream in 9.4.0.
      (fetchpatch {
        name = "CVE-2026-27824.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/2f273444460d06f72f7a8f390f5f9ff325d1f836.patch";
        hash = "sha256-xKkt8v/HFB3swY6dKlMrycPt5NCFN4FRH3iRO/1aokQ=";
      })
      # Fix CVE-2026-30853
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0656
      # https://github.com/NixOS/nixpkgs/issues/500148
      # Fixed upstream in 9.5.0.
      (fetchpatch {
        name = "CVE-2026-30853.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/0f8dc639337d9ace67201e15ca12d5906d05f4c8.patch";
        hash = "sha256-P/x1dsxHQ1cp/H34CIXvBvge2LCEQ1QKrTuJwpOEunY=";
      })
      # Fix CVE-2026-33205
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0824
      # https://github.com/NixOS/nixpkgs/issues/504457
      # Fixed upstream in 9.6.0.
      (fetchpatch {
        name = "CVE-2026-33205.1.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/6eb7b5458f183c8a037e9d7dac428122a77204e4.patch";
        hash = "sha256-JhMTuvqR0CZ1zNYC3pKRnu07ftl71Z/IDS3sKa3i2Ic=";
      })
      (fetchpatch {
        name = "CVE-2026-33205.2.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/b1ef6a8142b8dadeb7e72c250c65d42b36ee7118.patch";
        hash = "sha256-1uZ2c+yUilt06okc0vSgilPrmvluAodbwEMEtdd/7JE=";
      })
      # Fix CVE-2026-33206
      # http://tracker.security.nixos.org/issues/NIXPKGS-2026-0825
      # https://github.com/NixOS/nixpkgs/issues/504458
      # Fixed upstream in 9.6.0.
      (fetchpatch {
        name = "CVE-2026-33206.patch";
        url = "https://github.com/kovidgoyal/calibre/commit/c43f347837dbc00d9a7b5ff15a228b6f6081e290.patch";
        hash = "sha256-rHDMaZ/P9Or6Asr9YZO1lmvNqEpoFfil1w98t713XdI=";
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
      ++ lib.optionals (lib.lists.elem stdenv.hostPlatform.system pyqt6-webengine.meta.platforms) [
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
  installCheckPhase =
    let
      excludedTestNames = [
        "test_7z" # we don't include 7z support
        "test_zstd" # we don't include zstd support
        "test_qt" # we don't include svg or webp support
        "test_import_of_all_python_modules" # explores actual file paths, gets confused
        "test_websocket_basic" # flaky

        # hangs with cuda enabled, also:
        # eglInitialize: Failed to get system egl display
        # Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
        "test_recipe_browser_webengine"
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
