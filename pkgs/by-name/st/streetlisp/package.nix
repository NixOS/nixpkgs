{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "streetlisp";
  version = "0-unstable-2025-05-29";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "sl";
    rev = "13d367cd8a7b309afc4cffe555b9928d121083d4";
    hash = "sha256-0apaddT03UX3znFIVjsNxcOZG7RE9q5T/+HtHTT6rgQ=";
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
    homepage = "https://sr.ht/~ft/StreetLISP";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [
      qbit
    ];
    platforms = lib.platforms.unix;
    mainProgram = "sl";
  };
}
