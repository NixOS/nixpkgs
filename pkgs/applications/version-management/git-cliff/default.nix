{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-GRvZ9jdooduFylTGgUQNjdnD2Aa+jT5faV0/c3GBpqw=";
  };

  cargoHash = "sha256-vgVTHTEKfjWJzxDQ5w0dwp9qxyN5sgbBseXHN25bx9o=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security SystemConfiguration
  ];

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
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}
