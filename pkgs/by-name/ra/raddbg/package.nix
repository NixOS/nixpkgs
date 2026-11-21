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
  version = "0-unstable-2026-10-07"; # Unstable until https://github.com/EpicGames/raddebugger/issues/985 is in a release
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    rev = "b6d8c3fd9eaf7b55960d80738365742a8fba9e29";
    hash = "sha256-rBGvDwYTX+s7ArSxBBeEWbGLF031OaOfubK8+KUl+xU=";
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
