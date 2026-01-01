{
  lib,
  stdenv,
  fetchFromSourcehut,
<<<<<<< HEAD
  meson,
  ninja,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "femtolisp";
<<<<<<< HEAD
  version = "0-unstable-2025-12-18";
=======
  version = "0-unstable-2024-06-18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "femtolisp";
<<<<<<< HEAD
    rev = "08f9a4fda14ceb9b1d5879b6631dca02ba818401";
    hash = "sha256-xbkHlVUEpUOIMzEQy/90jMMD8J6cm0UNHAiCrfDDid8=";
=======
    rev = "ee58f398fec62d3096b0e01da51a3969ed37a32d";
    hash = "sha256-pfPD9TNLmrqhvJS/aVVmziMVApsiU5v1nAMqU+Kduzw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  strictDeps = true;

  enableParallelBuilding = true;

<<<<<<< HEAD
  nativeBuildInputs = [
    meson
    ninja
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ sl
=======
  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ flisp
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    mainProgram = "sl";
=======
    mainProgram = "flisp";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
