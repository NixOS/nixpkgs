{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "carapace-bridge";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y69byUUDJJ+nJuZ6lcl+McFtJGYb5zgE8+QTbhoZ9Bc=";
  };

  # buildGoModule try to run `go mod vendor` instead of `go work vendor` on the
  # workspace if proxyVendor is off
  proxyVendor = true;
  vendorHash = "sha256-TVqQrqdMmzv1w4Y37pB2t/apdMPm6QO/0VVS3x86GpE=";

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
    changelog = "https://github.com/carapace-sh/carapace-bridge/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ famfo ];
    license = lib.licenses.mit;
    mainProgram = "carapace-bridge";
  };
})
