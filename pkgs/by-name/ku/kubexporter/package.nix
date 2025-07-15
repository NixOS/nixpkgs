{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kubexporter";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "bakito";
    repo = "kubexporter";
    tag = "v${version}";
    hash = "sha256-lMXs19E52LHDtVytgP/qgkKGeiz3/5KvoYeY0wlkgT8=";
  };

  vendorHash = "sha256-b4bqAhgcVgLhdLX6isRM9bbnFLfmVb4O2hhJUGqWgb0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bakito/kubexporter/version.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exporting Kubernetes resources as YAML or JSON files";
    homepage = "https://github.com/bakito/kubexporter";
    changelog = "https://github.com/bakito/kubexporter/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bakito ];
    mainProgram = "kubexporter";
  };
}
