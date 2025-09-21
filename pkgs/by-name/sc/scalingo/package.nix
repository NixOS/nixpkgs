{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "scalingo";
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    hash = "sha256-5La3k6DXCYpnTgtnHolJ5pL7EPjkO+bXgT48gcRsbsc=";
  };

  vendorHash = null;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    rm $out/bin/dists
    installShellCompletion --cmd scalingo \
     --bash cmd/autocomplete/scripts/scalingo_complete.bash \
     --zsh cmd/autocomplete/scripts/scalingo_complete.zsh
  '';

  meta = with lib; {
    description = "Command line client for the Scalingo PaaS";
    mainProgram = "scalingo";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
