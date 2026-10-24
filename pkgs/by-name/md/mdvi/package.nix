{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdvi";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "taf2";
    repo = "mdvi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//nu1DzswDw14gzs/hRGAnMgsHEuARX9p/BwjQTWtyM=";
  };

  cargoHash = "sha256-AtM0AMP/ICqNamKfdI/MaHMK8uFfjlHIKAZYASA2yHk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal markdown viewer with Vim-style navigation";
    homepage = "https://github.com/taf2/mdvi";
    changelog = "https://github.com/taf2/mdvi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "mdvi";
  };
})
