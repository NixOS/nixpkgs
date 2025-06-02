{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-ZxMwQBhU+49+MaId16tH2np2slgCmq4yKi6PI9Dy+o4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QPxrdmuQINzuZXyRRYDA+HguRdt6n++XuLj/OF0ceKU=";

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

  meta = with lib; {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      siraben
      matthiasbeyer
    ];
    mainProgram = "git-cliff";
  };
}
