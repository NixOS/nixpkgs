{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "csview";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "csview";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JFuqaGwCSfEIncBgLu6gGaOvAC5vojKFjruWcuSghS0=";
  };

  cargoHash = "sha256-CXIfE1EsNwm4vsybQSdfKewBYpzBh+uQu1jYAm8DDtI=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    changelog = "https://github.com/wfxr/csview/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
