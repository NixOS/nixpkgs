{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook269,
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
  unstableGitUpdater,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation {
  pname = "abiword";
  version = "0-unstable-2024-11-02";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AbiWord";
    rev = "542cb5c8aa0a97efd033f78d29f706d1fbae74e7";
    hash = "sha256-1/lr0sCHhDAJCSnbTxIyoe7GOiJlnjcXqItpP9VO0GE=";
  };

  patches = [
    # https://gitlab.gnome.org/World/AbiWord/-/merge_requests/19
    ./fix-nonnull-implicit-this-build-failure.patch
  ];

  nativeBuildInputs =
    [
      autoreconfHook269
      autoconf-archive
      pkg-config
      wrapGAppsHook3
      perl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      desktopToDarwinBundle
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

    # cocoa implementation is broken and incomplete
    substituteInPlace configure.ac \
      --replace-fail 'TOOLKIT="cocoa"' 'TOOLKIT="gtk"'
  '';

  preAutoreconf = ''
    ./autogen-common.sh
  '';

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-ljpeg -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lgmodule-2.0";

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true; # tags are not defined on the master branch
  };

  meta = with lib; {
    description = "Word processing program, similar to Microsoft Word";
    mainProgram = "abiword";
    homepage = "https://gitlab.gnome.org/World/AbiWord/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pSub
      ylwghst
      sna
    ];
  };
}
