{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "hcloud-upload-image";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "apricote";
    repo = "hcloud-upload-image";
    tag = "v${version}";
    hash = "sha256-1u9tpzciYjB/EgBI81pg9w0kez7hHZON7+AHvfKW7k0=";
  };

  vendorHash = "sha256-IdOAUBPg0CEuHd2rdc7jOlw0XtnAhr3PVPJbnFs2+x4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
    changelog = "https://github.com/apricote/hcloud-upload-image/releases/tag/v${version}";
    description = "Quickly upload any raw disk images into your Hetzner Cloud projects";
    mainProgram = "hcloud-upload-image";
    homepage = "https://github.com/apricote/hcloud-upload-image";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sshine
    ];
  };
}
