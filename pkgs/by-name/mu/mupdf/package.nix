{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  fetchpatch,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  buildPackages,
  pkg-config,
  fixDarwinDylibNames,
  freetype,
  harfbuzz,
  openjpeg,
  jbig2dec,
  libjpeg,
  gumbo,
  enableX11 ? (!stdenv.hostPlatform.isDarwin),
  libX11,
  libXext,
  libXi,
  libXrandr,
  enableCurl ? true,
  curl,
  openssl,
  enableGL ? true,
  freeglut,
  libGLU,
  enableOcr ? false,
  leptonica,
  tesseract,
  enableCxx ? false,
  python3,
  enablePython ? false,
  which,
  swig,
  xcbuild,
  gitUpdater,
  enableBarcode ? false,

  # for passthru.tests
  cups-filters,
  zathura,
  mupdf,
}:

assert enablePython -> enableCxx;

let

  freeglut-mupdf = freeglut.overrideAttrs (old: rec {
    pname = "freeglut-mupdf";
    version = "3.0.0-r${src.rev}";
    src = fetchFromGitHub {
      owner = "ArtifexSoftware";
      repo = "thirdparty-freeglut";
      rev = "13ae6aa2c2f9a7b4266fc2e6116c876237f40477";
      hash = "sha256-0fuE0lm9rlAaok2Qe0V1uUrgP4AjMWgp3eTbw8G6PMM=";
    };

    patches = [ ];

    # cmake 4 compatibility, upstream is dead
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.8 FATAL_ERROR)" "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)"
    '';
  });

in

stdenv.mkDerivation rec {
  version = "1.26.8";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    hash = "sha256-6NJIpmbSOG9KIBTWgLbojeXOn9jIR7DidMvswSTzPMc=";
  };

  patches = [
    # Upstream makefile does not work with system deps on macOS by default, so
    # we reuse the Linux section instead.
    ./fix-darwin-system-deps.patch
    # Upstream C++ wrap script only defines fixed-sized integers on macOS but
    # this is required on aarch64-linux too.
    ./fix-cpp-build.patch
  ]
  # fix compatibility with Clang >= 20
  ++ lib.optionals enableCxx [
    (fetchpatch {
      name = "scripts-wrap-parse.py-get_args-improve-caching-of-re.patch";
      url = "https://github.com/ArtifexSoftware/mupdf/commit/559e45ac8c134712cd8eaee01536ea3841e3a449.patch";
      hash = "sha256-gI3hzrNo6jj9eqQ9E/BJ3jxXi/sl1C5WRyYlkG3Gkfg=";
    })
    (fetchpatch {
      name = "scripts-wrap-parse.py-get_args-fix-for-libclang-20.patch";
      url = "https://github.com/ArtifexSoftware/mupdf/commit/4bbf411898341d3ba30f521a6c137a788793cd45.patch";
      hash = "sha256-cxKNziAGjpDwEw/9ZQHslMeJbiqYo80899BDkUOIX8g=";
    })
  ];

  postPatch = ''
    substituteInPlace Makerules --replace-fail "(shell pkg-config" "(shell $PKG_CONFIG"

    patchShebangs scripts/mupdfwrap.py

    # slip in makeFlags when building bindings
    sed -i -e 's/^\( *make_args *=\)/\1 """ $(echo ''${makeFlagsArray[@]@Q})"""/' scripts/wrap/__main__.py

    # fix libclang unnamed struct format
    for wrapper in ./scripts/wrap/{cpp,state}.py; do
      substituteInPlace "$wrapper" --replace-fail 'struct (unnamed' '(unnamed struct'
    done
  '';

  makeFlags = [
    "prefix=$(out)"
    "shared=yes"
    "USE_SYSTEM_LIBS=yes"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ]
  ++ lib.optionals (!enableX11) [ "HAVE_X11=no" ]
  ++ lib.optionals (!enableGL) [ "HAVE_GLUT=no" ]
  ++ lib.optionals enableOcr [ "USE_TESSERACT=yes" ]
  ++ lib.optionals enableBarcode [
    "barcode=yes"
    "USE_SYSTEM_ZXINGCPP=no"
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (enableGL || enableX11) copyDesktopItems
  ++ lib.optional (stdenv.hostPlatform.isDarwin && (enableGL || enableX11)) desktopToDarwinBundle
  ++ lib.optionals (enableCxx || enablePython) [
    (python3.pythonOnBuildForHost.withPackages (ps: [
      ps.setuptools
      ps.libclang
    ]))
  ]
  ++ lib.optionals enablePython [
    which
    swig
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
    xcbuild
  ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg
    gumbo
  ]
  ++ lib.optionals enableX11 [
    libX11
    libXext
    libXi
    libXrandr
  ]
  ++ lib.optionals enableCurl [
    curl
    openssl
  ]
  ++ lib.optionals (enableGL && !stdenv.hostPlatform.isDarwin) [
    freeglut-mupdf
    libGLU
  ]
  ++ lib.optionals enableOcr [
    leptonica
    tesseract
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  preConfigure = ''
    # Don't remove mujs or zxing-cpp because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  postBuild = lib.optionalString (enableCxx || enablePython) ''
    for dir in build/*; do
      ./scripts/mupdfwrap.py -d "$dir" -b ${lib.optionalString enableCxx "01"}${lib.optionalString enablePython "23"}
    done
  '';

  desktopItems = lib.optionals (enableGL || enableX11) [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      comment = meta.description;
      icon = "mupdf";
      exec = "${pname} %f";
      terminal = false;
      mimeTypes = [
        "application/epub+zip"
        "application/oxps"
        "application/pdf"
        "application/vnd.ms-xpsdocument"
        "application/x-cbz"
        "application/x-pdf"
      ];
      categories = [
        "Graphics"
        "Viewer"
      ];
      keywords = [
        "mupdf"
        "comic"
        "document"
        "ebook"
        "viewer"
        "cbz"
        "epub"
        "fb2"
        "pdf"
        "xps"
      ];
    })
  ];

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Version: ${version}
    Libs: -L\''${libdir} -lmupdf
    Cflags: -I\''${includedir}
    EOF

    moveToOutput "bin" "$bin"
  ''
  + (lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    for exe in $bin/bin/*; do
      install_name_tool -change build/shared-release/libmupdf.dylib $out/lib/libmupdf.dylib "$exe"
    done
  '')
  + (lib.optionalString (enableX11 || enableGL) ''
    mkdir -p $bin/share/icons/hicolor/48x48/apps
    cp docs/logo/mupdf-icon-48.png $bin/share/icons/hicolor/48x48/apps/mupdf.png
  '')
  + (
    if enableGL then
      ''
        ln -s "$bin/bin/mupdf-gl" "$bin/bin/mupdf"
      ''
    else
      lib.optionalString enableX11 ''
        ln -s "$bin/bin/mupdf-x11" "$bin/bin/mupdf"
      ''
  )
  + (lib.optionalString enableCxx ''
    cp platform/c++/include/mupdf/*.h $out/include/mupdf
    cp build/*/libmupdfcpp.so* $out/lib
  '')
  + (lib.optionalString enablePython (
    ''
      mkdir -p $out/${python3.sitePackages}/mupdf
      cp build/*/_mupdf.so $out/${python3.sitePackages}/mupdf
      cp build/*/mupdf.py $out/${python3.sitePackages}/mupdf/__init__.py
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      install_name_tool -add_rpath $out/lib $out/${python3.sitePackages}/mupdf/_mupdf.so
    ''
  ));

  enableParallelBuilding = true;

  env.USE_SONAME = if (stdenv.hostPlatform.isDarwin) then "no" else "yes";

  passthru = {
    tests = {
      inherit cups-filters zathura;
      inherit (python3.pkgs) pikepdf pymupdf;
      mupdf-all = mupdf.override {
        enableCurl = true;
        enableGL = true;
        enableOcr = true;
        enableCxx = true;
        enablePython = true;
      };
    };

    updateScript = gitUpdater {
      url = "https://cgit.ghostscript.com/cgi-bin/cgit.cgi/mupdf.git";
      ignoredVersions = ".rc.*";
    };
  };

  meta = {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    changelog = "https://cgit.ghostscript.com/cgi-bin/cgit.cgi/mupdf.git/plain/CHANGES?h=refs/tags/${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.unix;
    mainProgram = "mupdf";
  };
}
