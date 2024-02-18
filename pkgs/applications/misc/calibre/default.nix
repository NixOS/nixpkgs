{ lib
, stdenv
, cmake
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
, removeReferencesTo
, speechd
, sqlite
, wrapQtAppsHook
, xdg-utils
, wrapGAppsHook
, unrarSupport ? false
, isocodes
, cacert
, zip
, fetchFromGitHub
, sphinx
, liberation_ttf
, mathjax ? fetchFromGitHub {
    repo = "MathJax";
    owner = "mathjax";
    rev = "3.1.4";
    hash = "sha256-viEg8xBUAsrMRH2m5fMXhcejMuN5bR+EntIGgP0Rb+c=";
  }
, hyphenation ? fetchFromGitHub {
    owner = "LibreOffice";
    repo = "dictionaries";
    rev = "libreoffice-7.6.5.2";
    sha256 = "sha256-hGXumAvZXa5Rl/PANLsEV23YE50QjPmzA51DYKhvQBk=";
  }
, translations ? fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "calibre-translations";
    rev = "bce1a26a9be187e6daf57fb6548d3fc7ad5a709a";
    sha256 = "sha256-2rMosLGcJNFQPlAjHI+ft+IApdsERdK4aVLgcrGShzc=";
  }
}:
let
  iso-codes-zip = stdenv.mkDerivation rec {
    pname = "iso-codes-zip";
    inherit (isocodes) src version;
    nativeBuildInputs = [ zip ];
    unpackPhase = "true";
    buildPhase = ''
      tar xzf ${src}
      zip main.zip $(tar tf ${src})
    '';
    installPhase = "cp main.zip $out";
  };
  liberation_fonts = "${liberation_ttf}/share/fonts/truetype";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "calibre";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FH9+MHJkHJYEaxoqTTlm6gJkq+RpdXoK5F2erZP+ECI=";
  };

  patches = [
    #  allow for plugin update check, but no calibre version check
    (fetchpatch {
      name = "0001-only-plugin-update.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${finalAttrs.version}+ds-1/debian/patches/0001-only-plugin-update.patch";
      hash = "sha256-uL1mSjgCl5ZRLbSuKxJM6XTfvVwog70F7vgKtQzQNEQ=";
    })
    (fetchpatch {
      name = "0007-Hardening-Qt-code.patch";
      url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/${finalAttrs.version}+ds-1/debian/patches/hardening/0007-Hardening-Qt-code.patch";
      hash = "sha256-a6yyG0RUsQJBBNxeJsTtQSBV2lxdzz1hnTob88O+SKg=";
    })
    (fetchpatch {
      name = "build-from-git-without-internet";
      url = "https://github.com/wrvsrx/calibre/commit/4b7c79f71821e9d13edff5d04249c5decf1093a0.patch";
      hash = "sha256-1czbc5Z5BsvtyVWnQwFH3Wsn+31RfahjulwtXHJVQKA=";
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

  nativeBuildInputs = [
    cmake
    pkg-config
    qmake
    removeReferencesTo
    wrapGAppsHook
    wrapQtAppsHook
    sphinx
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
    qtwayland
    sqlite
    xdg-utils
  ] ++ (
    with python3Packages; [
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
    ] ++ lib.optionals (lib.lists.any (p: p == stdenv.hostPlatform.system) pyqt6-webengine.meta.platforms) [
      # much of calibre's functionality is usable without a web
      # browser, so we enable building on platforms which qtwebengine
      # does not support by simply omitting qtwebengine.
      pyqt6-webengine
    ] ++ lib.optional (unrarSupport) unrardll
  );

  env = {
    POPPLER_INC_DIR = "${poppler_utils.dev}/include/poppler";
    POPPLER_LIB_DIR = "${poppler_utils.out}/lib";
    MAGICK_INC = "${imagemagick.dev}/include/ImageMagick";
    MAGICK_LIB = "${imagemagick.out}/lib";
    FC_INC_DIR = "${fontconfig.dev}/include/fontconfig";
    FC_LIB_DIR = "${fontconfig.lib}/lib";
    PODOFO_INC_DIR = "${podofo.dev}/include/podofo";
    PODOFO_LIB_DIR = "${podofo.lib}/lib";
    ISOCODE_ZIP = "${iso-codes-zip}";
    ISOCODE_VERSION = iso-codes-zip.version;
    CACERT = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    TRANSLATIONS = "${translations}";
    # this is get from https://code.calibre-ebook.com/ua-popularity
    # It's not reproducible, so we have to pack it in repo
    # this file can be generated using `python fetch-ua.py`
    UA_POPULARITY = "${./ua-popularity.txt}";
  };

  buildPhase = ''
    mkdir temp
    cp "${cacert}/etc/ssl/certs/ca-bundle.crt" resources/mozilla-ca-certs.pem
    ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py bootstrap \
      --path-to-mathjax=${mathjax} \
      --path-to-liberation_fonts=${liberation_fonts} \
      --path-to-hyphenation=${hyphenation}
    ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py man_pages
  '';

  installPhase = ''
    runHook preInstall

    export HOME=$TMPDIR/fakehome

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
    license =
      if unrarSupport
      then lib.licenses.unfreeRedistributable
      else lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
  passthru.updateScript = ./fetch-ua.py;
})
