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

stdenv.mkDerivation (finalAttrs: {
  pname = "abiword";
  version = "3.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AbiWord";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-TjOHixfCXDQlUUbD1L5wcGe4Nl0+1UqZw4EF+1/eZ4w=";
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
})
