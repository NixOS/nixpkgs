{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "hcloud-upload-image";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "apricote";
    repo = "hcloud-upload-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l2LFx1f7X4t8yELWqryJgLW8Mr5Wey9AbI2wCpA2GJ0=";
  };

  vendorHash = "sha256-hKsyweWmLZ0zH8VRX//YWYszbdmwrH5LCHn/SKeDbuk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/hcloud-upload-image completion $shell > hcloud.$shell
      installShellCompletion hcloud.$shell
    done
  '';

  env.GOWORK = "off";

  meta = {
    changelog = "https://github.com/apricote/hcloud-upload-image/releases/tag/v${finalAttrs.version}";
    description = "Quickly upload any raw disk images into your Hetzner Cloud projects";
    mainProgram = "hcloud-upload-image";
    homepage = "https://github.com/apricote/hcloud-upload-image";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sshine
    ];
  };
})
