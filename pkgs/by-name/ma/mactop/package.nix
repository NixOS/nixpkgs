{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "mactop";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "context-labs";
    repo = "mactop";
    tag = "v${version}";
    hash = "sha256-xWUCOmNwhxmutY7G+FmxT7mabexuBIcgFzX++zsdnN4=";
  };

  vendorHash = "sha256-BFvd1jJzGYsI2E6BdFy+BwHOAy7VgblcByV/oRCKORs=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Terminal-based monitoring tool 'top' designed to display real-time metrics for Apple Silicon chips";
    homepage = "https://github.com/context-labs/mactop";
    changelog = "https://github.com/context-labs/mactop/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mactop";
    platforms = [ "aarch64-darwin" ];
  };
}
