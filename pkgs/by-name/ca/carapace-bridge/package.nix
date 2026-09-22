{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "carapace-bridge";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ynxraHtqj0C/AUlRtX3vQRHm0hfnirNAfeYcf+jTHA4=";
  };

  # buildGoModule tries to run `go mod vendor` instead of `go work vendor` on
  # the workspace if proxyVendor is off
  proxyVendor = true;
  vendorHash = "sha256-+xAR51kWnMlJrhC5c3yN0qZEBcmmcAqiUlvEFgNStuM=";

  postPatch = ''
    substituteInPlace cmd/carapace-bridge/main.go \
      --replace-fail "var version = \"develop\"" "var version = \"$version\""

    # Remove docker examples
    rm -r .docker
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
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
