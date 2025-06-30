{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "metal-cli";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = "metal-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+hpsGFZHuVhh+fKVcap0vhoUmRs3xPgUwW8SD56m6uI=";
  };

  vendorHash = "sha256-X+GfM73LAWk2pT4ZOPT2pg8YaKyT+SNjQ14LgB+C7Wo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/equinix/metal-cli/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd metal \
      --bash <($out/bin/metal completion bash) \
      --fish <($out/bin/metal completion fish) \
      --zsh <($out/bin/metal completion zsh)
  '';

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/metal";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    changelog = "https://github.com/equinix/metal-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      nshalman
      teutat3s
    ];
    mainProgram = "metal";
  };
})
