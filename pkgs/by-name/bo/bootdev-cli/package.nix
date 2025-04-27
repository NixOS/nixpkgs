{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "bootdev-cli";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "bootdotdev";
    repo = "bootdev";
    tag = "v${version}";
    hash = "sha256-5S4XjqajX1Y9XKxfWFDeFVC2d14/C9fo6zytbwXuW7E=";
  };

  vendorHash = "sha256-jhRoPXgfntDauInD+F7koCaJlX4XDj+jQSe/uEEYIMM=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bootdev \
      --bash <($out/bin/bootdev completion bash) \
      --zsh <($out/bin/bootdev completion zsh) \
      --fish <($out/bin/bootdev completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/bootdev";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI used to complete coding challenges and lessons on Boot.dev";
    homepage = "https://github.com/bootdotdev/bootdev";
    changelog = "https://github.com/bootdotdev/bootdev/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "bootdev";
  };
}
