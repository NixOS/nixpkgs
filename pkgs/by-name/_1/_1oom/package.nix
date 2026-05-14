{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "1.11.8";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "1oom-fork";
    repo = "1oom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y29Xc8ylXhpQO7dDl7z7XC7+RB4UOIRksZ8RtfaCiEc=";
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
  enableParallelBuilding = true;

  postInstall = ''
    install -d $doc/share/doc/1oom
    install -t $doc/share/doc/1oom \
      HACKING NEWS PHILOSOPHY README.md doc/*.txt
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/1oom-fork/1oom";
    changelog = "https://github.com/1oom-fork/1oom/releases/tag/v${finalAttrs.version}";
    description = "Master of Orion (1993) game engine recreation; a more updated fork";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ marcin-serwin ];
  };
})
