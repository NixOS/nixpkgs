{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  gtk3,
  fribidi,
  libpng,
  popt,
  libgsf,
  enchant,
  wv,
  librsvg,
  bzip2,
  libjpeg,
  perl,
  boost,
  libxslt,
  goffice,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "abiword";
  version = "3.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AbiWord";
    rev = "refs/tags/release-${version}";
    hash = "sha256-dYbJ726Zuxs7+VTTCWHYQLsVZ/86hRUBQRac6toO4UI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    wrapGAppsHook3
    perl
  ];

  buildInputs = [
    gtk3
    librsvg
    bzip2
    fribidi
    libpng
    popt
    libgsf
    enchant
    wv
    libjpeg
    boost
    libxslt
    goffice
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./tools/cdump/xp/cdump.pl ./po/ui-backport.pl
  '';

  preAutoreconf = ''
    ./autogen-common.sh
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "release-";
  };

  meta = {
    description = "Word processing program, similar to Microsoft Word";
    mainProgram = "abiword";
    homepage = "https://gitlab.gnome.org/World/AbiWord/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pSub
      ylwghst
      sna
    ];
  };
}
