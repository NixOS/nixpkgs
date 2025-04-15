{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "mpls";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${version}";
    hash = "sha256-sr0NZGQoaJw8LYJy13iNNos06KDHXNPbYSw3UAHi6eg=";
  };

  vendorHash = "sha256-xILlYrwcnMWAPACeELwVKGUBIK9QbrUSR03xVmNXsnE=";

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
