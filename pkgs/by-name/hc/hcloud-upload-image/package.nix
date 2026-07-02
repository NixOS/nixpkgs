{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "hcloud-upload-image";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "apricote";
    repo = "hcloud-upload-image";
    tag = "v${version}";
    hash = "sha256-3ToqN7Fu1YzmGMnv1ZNRutYGMZ0fAKSIvyJEes+S3+Q=";
  };

  vendorHash = "sha256-IDtrD2P4lPl2q4Hu4fEQEjopE43CQ5xkFZQWOEvuR2U=";

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
