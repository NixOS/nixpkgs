{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "guesswidth";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "guesswidth";
    tag = "v${version}";
    hash = "sha256-afZYegG4q+KmvNP2yy/HGvP4V1mpOUCxRLWLTUHAK0M=";
  };

  vendorHash = "sha256-IGb+fM3ZOlGrLGFSUeUhZ9wDMKOBofDBYByAQlvXY14=";

  ldflags = [
    "-X github.com/noborus/guesswidth.version=v${version}"
    "-X github.com/noborus/guesswidth.revision=${src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd guesswidth \
        --bash <(${emulator} $out/bin/guesswidth completion bash) \
        --fish <(${emulator} $out/bin/guesswidth completion fish) \
        --zsh <(${emulator} $out/bin/guesswidth completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Guess the width (fwf) output without delimiters in commands that output to the terminal";
    homepage = "https://github.com/noborus/guesswidth";
    changelog = "https://github.com/noborus/guesswidth/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "guesswidth";
  };
}
