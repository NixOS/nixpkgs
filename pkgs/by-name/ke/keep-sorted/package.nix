{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "keep-sorted";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1WkxZRxXafz8xTmdy0aP+jqWsuwQlvkZSmEjnlmHBaA=";
  };

  vendorHash = "sha256-HTE9vfjRmi5GpMue7lUfd0jmssPgSOljbfPbya4uGsc=";

  # Inject version string instead of reading version from buildinfo.
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail 'readVersion())' '"v${finalAttrs.version}")'
  '';

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  preCheck = ''
    # Test tries to find files using git in init func.
    rm goldens/*_test.go
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/google/keep-sorted/releases/tag/v${finalAttrs.version}";
    description = "Language-agnostic formatter that sorts lines between two markers in a larger file";
    homepage = "https://github.com/google/keep-sorted";
    license = lib.licenses.asl20;
    mainProgram = "keep-sorted";
    maintainers = with lib.maintainers; [ katexochen ];
  };
})
