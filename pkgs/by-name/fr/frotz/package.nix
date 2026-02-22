{
  lib,
  stdenv,
  fetchFromGitLab,
  libao,
  libmodplug,
  libsamplerate,
  libsndfile,
  libvorbis,
  ncurses,
  which,
  pkg-config,
  SDL2,
  SDL2_mixer,
  zlib,
  libjpeg,
  libpng,
  freetype,
  frontend ? "ncurses",
}:

assert lib.assertOneOf "frontend" frontend [
  "ncurses"
  "sdl"
  # NOTE: more options are present in the Makefile, e.g., x11, dumb, nosound, ...
];
let
  progName = if frontend == "ncurses" then "frotz" else "sfrotz";
in
stdenv.mkDerivation (finalAttrs: {
  pname = progName;
  version = "2.55";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    tag = finalAttrs.version;
    hash = "sha256-XZjimskjupTtYdgfVaOS2QnQrDIBSwkJqxrffdjgZk0=";
  };

  patches = [
    # https://gitlab.com/DavidGriffith/frotz/-/merge_requests/226
    ./0001-Fix-SDL_SOUND_CFLAGS-usage.patch
  ];

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [
    which
    pkg-config
  ];
  buildInputs = [
    libao
    libmodplug
    libsamplerate
    libsndfile
    libvorbis
  ]
  ++ (
    if frontend == "ncurses" then
      [ ncurses ]
    else
      [
        freetype
        libjpeg
        libpng
        SDL2
        SDL2_mixer
        zlib
      ]
  );

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "HOMEBREW_PREFIX=/var/empty"
  ];
  preConfigure = ''
    makeFlagsArray+=(CURSES_CONFIG="$PKG_CONFIG ncurses")
  '';

  buildFlags = [ frontend ];
  installTargets = if frontend == "ncurses" then "install-frotz" else "install-${frontend}";

  meta = {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${finalAttrs.version}/NEWS";
    description = "Z-machine interpreter for Infocom games and other interactive fiction (${frontend})";
    mainProgram = progName;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nicknovitski
      ddelabru
    ];
    license = lib.licenses.gpl2Plus;
  };
})
