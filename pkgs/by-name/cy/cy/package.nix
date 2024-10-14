{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "cy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cfoust";
    repo = "cy";
    rev = "refs/tags/v1.0.0";
    hash = "sha256-W7xCAeoBn6nrSzkBX59qulIcgigeHhaaa38vfEEuaAQ=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$PWD/.cache/go-build
    go install ./cmd/cy/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin $GOPATH/bin/cy
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cfoust/cy";
    description = "Time traveling terminal multiplexer";
    longDescription = ''
      cy is an experimental terminal multiplexer that aims to be a simple, modern, and ergonomic alternative to tmux. Major features:
      * Replay and search through any terminal session
      * Shell command history that lets you insert (and revisit) any command you've ever run
      * Flexible configuration with Janet, a simple imperative programming language
      * Built-in fuzzy finding using concepts from fzf
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "cy";
    maintainers = with lib.maintainers; [ pagedmov ];
  };
}
