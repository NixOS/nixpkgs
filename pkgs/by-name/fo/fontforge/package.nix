{
  stdenv,
  fetchFromGitHub,
  lib,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "fontforge";
  version = "20251009";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    tag = finalAttrs.version;
    hash = "sha256-tlpdd+x1mA+HeLXpy5LotNC6sabxI6U7S+m/qOn1jwc=";
  };

  patches = [
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
    export SOURCE_DATE_EPOCH=$(date -d ${finalAttrs.version} +%s)
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
})
