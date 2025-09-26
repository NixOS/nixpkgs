{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-AFNOnFX/U0HkVypzrt1LELMiXshgVJ6q52ga74V9J9w=";
  };

  cargoHash = "sha256-6B65R/6VVUm7OZs/8UmJTEQ0htWBas1kxQj0qQ0QW+4=";

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
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      siraben
      matthiasbeyer
    ];
    mainProgram = "git-cliff";
  };
}
