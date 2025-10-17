{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orb";
  version = "0-unstable-2025-08-09";

  src = fetchFromGitHub {
    owner = "ayuzur";
    repo = "orb";
    rev = "d346d71aa56d8cb017f01add8b94b6c11fce83a5";
    hash = "sha256-455vS/lUzcs6XGklF3yJC3mK0LVTcxQSfiaOQV5YxFA=";
  };

  strictDeps = true;

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "gcc" "$CC"
  '';

  installPhase = ''
    runHook preInstall

    install -D bin/orb --target-directory=$out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Exploding terminal orb timer";
    homepage = "https://github.com/ayuzur/orb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "orb";
    platforms = lib.platforms.all;
  };
})
