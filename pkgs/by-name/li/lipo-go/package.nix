{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  lipo-go,
}:
buildGoModule (finalAttrs: {
  pname = "lipo-go";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "konoui";
    repo = "lipo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WLk6heSnXZjZ6PZWEiUXxx8M5t8EgjpEsTRLeCTzcr8=";
  };
  vendorHash = "sha256-7M6CRxJd4fgYQLJDkNa3ds3f7jOp3dyloOZtwMtCBQk=";

  buildPhase = ''
    runHook preBuild

    make build VERSION=${finalAttrs.version} REVISION="" BINARY=$out/bin/lipo

    runHook postBuild
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/lipo";
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Designed to be compatible with macOS lipo, written in golang";
    homepage = "https://github.com/konoui/lipo";
    changelog = "https://github.com/konoui/lipo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "lipo";
  };
})
