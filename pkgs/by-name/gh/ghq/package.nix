{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  testers,
  nix-update-script,
  writableTmpDirAsHomeHook,
  ghq,
}:

buildGoModule (finalAttrs: {
  pname = "ghq";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Ro/PbI9UZ0l0OsfIQOlmX8GZBWBvAeKDgHpz8DrsQPM=";
  };

  vendorHash = "sha256-YToIkJozCyI1k5xqs4w6brVERJ2edR2PRob2tXWb9Ms=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-X=main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --bash $src/misc/bash/_ghq \
      --fish $src/misc/fish/ghq.fish \
      --zsh $src/misc/zsh/_ghq
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ghq;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote repository management made easy";
    homepage = "https://github.com/x-motemen/ghq";
    maintainers = with lib.maintainers; [ sigma ];
    license = lib.licenses.mit;
    mainProgram = "ghq";
  };
})
