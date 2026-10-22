{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "scalingo";
  version = "1.50.0";

  src = fetchFromGitHub {
    owner = "scalingo";
    repo = "cli";
    rev = version;
    hash = "sha256-Snsb9GopVslWOG/kZsHE4W2bFEbVZ7yTZvp8EwwNXmo=";
  };

  vendorHash = null;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    rm $out/bin/dists
    installShellCompletion --cmd scalingo \
     --bash cmd/autocomplete/scripts/scalingo_complete.bash \
     --zsh cmd/autocomplete/scripts/scalingo_complete.zsh
  '';

  meta = {
    description = "Command line client for the Scalingo PaaS";
    mainProgram = "scalingo";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
