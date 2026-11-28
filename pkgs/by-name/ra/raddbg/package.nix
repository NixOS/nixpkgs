{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeWrapper,
  freetype,
  libx11,
  libxext,
  libxfixes,
  libxrandr,
  libGL,
  # At runtime
  llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raddbg";
  version = "0.9.29-alpha-unstable-2026-11-04"; # Unstable until https://github.com/EpicGames/raddebugger/issues/985 is in a release
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    rev = "5b0d5f67a46af5fffa52322e95a116dabf393103";
    hash = "sha256-fmFGAI2MCvvWAJ1GgmQ3rZOw5ocU+FzRpYSQeUH/z0o=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    freetype
    libx11
    libxext
    libxfixes
    libxrandr
    libGL
  ];

  buildPhase = ''
    runHook preBuild
    bash ./build.sh raddbg gcc release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/raddbg $out/bin/raddbg
    wrapProgram $out/bin/raddbg \
      --prefix PATH : ${lib.makeBinPath [ llvm ]}
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A native, user-mode, multi-process, graphical debugger";
    homepage = "https://github.com/EpicGames/raddebugger";
    changelog = "https://github.com/EpicGames/raddebugger/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "raddbg";
    platforms = [ "x86_64-linux" ];
  };
})
