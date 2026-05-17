{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pulumi-esc";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-umZEP3c7y/3DgcWj1iUH8wUUKFRw43jCrF+nZk62jXU=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-DNT1qwgtjSwLnSTru9jumwTIISCIhe5SGHz4CzE/fSo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/esc/cmd/esc/cli/version.Version=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "esc";
  };
})
