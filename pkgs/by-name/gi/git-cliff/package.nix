{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-cliff";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OFVJUZ3jSuDlHYIl/8KmJJW5ZbVI12wn+bVx9XeOkvI=";
  };

  cargoHash = "sha256-wkSLz6WGsfYZobbrOaDV79Xl7f4/nDkP3z8ZFP1Cn54=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export OUT_DIR=$(mktemp -d)

    # Generate shell completions
    $out/bin/git-cliff-completions
    installShellCompletion \
      --bash $OUT_DIR/git-cliff.bash \
      --fish $OUT_DIR/git-cliff.fish \
      --zsh $OUT_DIR/_git-cliff

    # Generate man page
    $out/bin/git-cliff-mangen
    installManPage $OUT_DIR/git-cliff.1
  '';

  meta = {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      siraben
      matthiasbeyer
    ];
    mainProgram = "git-cliff";
  };
})
