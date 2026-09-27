{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk4,
  libGLU,
  libepoxy,
  motif,
  gd,
  # similar as debian
  # https://salsa.debian.org/electronics-team/ringdove-eda/librnd/-/blob/debian/debian/rules
  librndBuildIn ? [
    "script" # optionally requires 'fungw', not packaged
    "diag_rnd"
    "lib_gensexpr"
    "hid_batch"
    "lib_portynet"
    "lib_exp_text"
    "import_pixmap_pnm"
    "lib_hid_common"
    "lib_hid_gl"
  ],
  librndPlugin ? [
    "lib_wget"
    "lib_gtk4_common"
    "import_pixmap_gd"
    "hid_lesstif"
    "hid_gtk4_gl"
    "irc"
    "lib_exp_pixmap"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librnd";
  version = "4.3.2";

  # Error: unknown argument bindir
  # outputs = [ "out" "dev" "doc" ];

  src = fetchurl {
    url = "http://repo.hu/projects/librnd/releases/librnd-${finalAttrs.version}.tar.gz";
    hash = "sha256-MSuQDeRtSgKboQ4viIxNKfvY+IhWqKQFucMArAOKgYU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk4
    libGLU
    libepoxy
    motif
    gd
  ];

  configureFlags =
    (lib.map (x: "--buildin-${x}") librndBuildIn) ++ (lib.map (x: "--plugin-${x}") librndPlugin);

  enableParallelBuilding = true;

  passthru = {
    inherit librndBuildIn librndPlugin;
  };

  meta = {
    description = "Flexible, modular two-dimensional CAD engine";
    homepage = "http://www.repo.hu/projects/librnd";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
  };
})
