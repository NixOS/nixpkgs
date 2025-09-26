{
  stdenv,
  fetchFromGitHub,
  lib,
  fetchpatch,
  replaceVars,
  cmake,
  pkg-config,
  python3,
  freetype,
  zlib,
  glib,
  giflib,
  libpng,
  libjpeg,
  libtiff,
  libxml2,
  cairo,
  pango,
  readline,
  woff2,
  zeromq,
  withSpiro ? false,
  libspiro,
  withGTK ? false,
  gtk3,
  withGUI ? withGTK,
  withPython ? true,
  withExtras ? true,
}:

assert withGTK -> withGUI;

let
  py = python3.withPackages (ps: with ps; [ setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "fontforge";
  version = "20230101";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = version;
    sha256 = "sha256-/RYhvL+Z4n4hJ8dmm+jbA1Ful23ni2DbCRZC5A3+pP0=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-25081.CVE-2024-25082.patch";
      url = "https://github.com/fontforge/fontforge/commit/216eb14b558df344b206bf82e2bdaf03a1f2f429.patch";
      hash = "sha256-aRnir09FSQMT50keoB7z6AyhWAVBxjSQsTRvBzeBuHU=";
    })

    # Replace distutils use in the build script
    (fetchpatch {
      name = "replace-distutils.patch";
      url = "https://github.com/fontforge/fontforge/commit/8c75293e924602ed09a9481b0eeb67ba6c623a81.patch";
      includes = [ "pyhook/CMakeLists.txt" ];
      hash = "sha256-3CEwC8vygmCztKRmeD45aZIqyoj8yk5CLwxX2SGP7z4=";
    })

    # Fixes translation compatibility with gettext 0.22
    (fetchpatch {
      name = "update-translation-compatibility.patch";
      url = "https://github.com/fontforge/fontforge/commit/642d8a3db6d4bc0e70b429622fdf01ecb09c4c10.patch";
      hash = "sha256-uO9uEhB64hkVa6O2tJKE8BLFR96m27d8NEN9UikNcvg=";
    })

    # Updates to new Python initialization API
    (fetchpatch {
      name = "modern-python-initialization-api.patch";
      url = "https://github.com/fontforge/fontforge/commit/2f2ba54c15c5565acbde04eb6608868cbc871e01.patch";
      hash = "sha256-qF4DqFpiZDbULi9+POPM73HF6pEot8BAFSVaVCNQrMU=";
    })

    # Provide a Nix-controlled location for the initial `sys.path` entry.
    (replaceVars ./set-python-sys-path.patch { python = "${py}/${py.sitePackages}"; })
  ];

  # use $SOURCE_DATE_EPOCH instead of non-deterministic timestamps
  postPatch = ''
    find . -type f -name '*.c' -exec sed -r -i 's#\btime\(&(.+)\)#if (getenv("SOURCE_DATE_EPOCH")) \1=atol(getenv("SOURCE_DATE_EPOCH")); else &#g' {} \;
    sed -r -i 's#author\s*!=\s*NULL#& \&\& !getenv("SOURCE_DATE_EPOCH")#g'                            fontforge/cvexport.c fontforge/dumppfa.c fontforge/print.c fontforge/svg.c fontforge/splineutil2.c
    sed -r -i 's#\bb.st_mtime#getenv("SOURCE_DATE_EPOCH") ? atol(getenv("SOURCE_DATE_EPOCH")) : &#g'  fontforge/parsepfa.c fontforge/sfd.c fontforge/svg.c
    sed -r -i 's#^\s*ttf_fftm_dump#if (!getenv("SOURCE_DATE_EPOCH")) ttf_fftm_dump#g'                 fontforge/tottf.c
    sed -r -i 's#sprintf\(.+ author \);#if (!getenv("SOURCE_DATE_EPOCH")) &#g'                        fontforgeexe/fontinfo.c
  '';

  # do not use x87's 80-bit arithmetic, rounding errors result in very different font binaries
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-msse2 -mfpmath=sse";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    readline
    woff2
    zeromq
    py
    freetype
    zlib
    glib
    giflib
    libpng
    libjpeg
    libtiff
    libxml2
  ]
  ++ lib.optionals withPython [ py ]
  ++ lib.optionals withSpiro [ libspiro ]
  ++ lib.optionals withGUI [
    gtk3
    cairo
    pango
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
  ]
  ++ lib.optional (!withSpiro) "-DENABLE_LIBSPIRO=OFF"
  ++ lib.optional (!withGUI) "-DENABLE_GUI=OFF"
  ++ lib.optional (!withGTK) "-DENABLE_X11=ON"
  ++ lib.optional (!withPython) "-DENABLE_PYTHON_SCRIPTING=OFF"
  ++ lib.optional withExtras "-DENABLE_FONTFORGE_EXTRAS=ON";

  preConfigure = ''
    # The way $version propagates to $version of .pe-scripts (https://github.com/dejavu-fonts/dejavu-fonts/blob/358190f/scripts/generate.pe#L19)
    export SOURCE_DATE_EPOCH=$(date -d ${version} +%s)
  '';

  meta = {
    description = "Font editor";
    homepage = "https://fontforge.github.io";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      philiptaron
      ulysseszhan
    ];
  };
}
