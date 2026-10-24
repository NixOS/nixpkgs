{
  lib,
  rustPlatform,
  fetchFromGitHub,
  jujutsu,
  git,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-navi";
  version = "0.2.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "eersnington";
    repo = "jj-navi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRjQnEi32XBn/AH6vsH6DwMS/qiLsaOTOIIJb1l3XvY=";
  };

  cargoHash = "sha256-MtmVEacT9cn1wpd+bTGX/Ba2pc7rtn1ibTnt4+xlE5M=";

  nativeCheckInputs = [
    jujutsu
    git
    writableTmpDirAsHomeHook
  ];

  # The tests compare against plain output, so the decoration Nix's builder pty
  # triggers has to go: NO_COLOR drops the color, TERM=dumb the hyperlink.
  preCheck = ''
    export NO_COLOR=1 TERM=dumb
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Workspace navigation and management for Jujutsu";
    homepage = "https://github.com/eersnington/jj-navi";
    changelog = "https://github.com/eersnington/jj-navi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "navi";
    maintainers = with lib.maintainers; [ cohei ];
  };
})
