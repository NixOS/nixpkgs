{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "femtolisp";
  version = "0-unstable-2025-12-18";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "femtolisp";
    rev = "08f9a4fda14ceb9b1d5879b6631dca02ba818401";
    hash = "sha256-xbkHlVUEpUOIMzEQy/90jMMD8J6cm0UNHAiCrfDDid8=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ sl

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Compact interpreter for a minimal lisp/scheme dialect";
    homepage = "https://git.sr.ht/~ft/femtolisp";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ moody ];
    broken = stdenv.hostPlatform.isDarwin;
    platforms = lib.platforms.unix;
    mainProgram = "sl";
  };
}
