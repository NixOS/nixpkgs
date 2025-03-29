{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "carapace-bridge";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bridge";
    tag = "v${version}";
    hash = "sha256-/HjoE6yaawo1hCemnvtfK3wj4SBSW91D4oyuZ5qxV4M=";
  };

  # buildGoModule try to run `go mod vendor` instead of `go work vendor` on the
  # workspace if proxyVendor is off
  proxyVendor = true;
  vendorHash = "sha256-zfV5IcpwtK3n76jWs4ldMlpEqbyNmmXZWDj+fh66luw=";

  postPatch = ''
    substituteInPlace cmd/carapace-bridge/main.go \
      --replace-fail "var version = \"develop\"" "var version = \"$version\""
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-shell completion bridge for carapace";
    homepage = "https://carapace.sh/";
    changelog = "https://github.com/carapace-sh/carapace-bridge/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ famfo ];
    license = lib.licenses.mit;
    mainProgram = "carapace-bridge";
  };
}
