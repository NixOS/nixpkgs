{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "mpls";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${version}";
    hash = "sha256-7uBhc4FRe9KxRloHJQoDb8JvKPcev2DuTftnMBnmiGs=";
  };

  vendorHash = "sha256-zEJBB5xJBJuLZQ/+yDyoFbkYXpqEkRXuIIhReBPKi+g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mhersson/mpls/cmd.Version=${version}"
    "-X github.com/mhersson/mpls/internal/mpls.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live preview of markdown using Language Server Protocol";
    homepage = "https://github.com/mhersson/mpls";
    changelog = "https://github.com/mhersson/mpls/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jervw ];
    mainProgram = "mpls";
  };
}
