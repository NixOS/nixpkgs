{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  autoreconfHook,
  allegro,
  libsamplerate,
  libx11,
  SDL2,
  SDL2_mixer,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "1oom";
  version = "1.11.9";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchgit {
    url = "https://git@git.sourcecraft.dev/fork1oom/1oom.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tU396z/7qpnhDEFqj/S55e/zeXa5jZFUi2VG3O6SJdY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    SDL2
  ];
  buildInputs = [
    allegro
    libsamplerate
    libx11
    SDL2
    SDL2_mixer
    readline
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  postInstall = ''
    install -Dm644 -t $doc/share/doc/1oom \
      HACKING NEWS PHILOSOPHY README.md doc/*.txt
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://fork1oom.sourcecraft.site/";
    changelog = "https://sourcecraft.dev/fork1oom/1oom/releases/v${finalAttrs.version}";
    description = "Master of Orion (1993) game engine recreation; a more updated fork";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ marcin-serwin ];
  };
})
