{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = version;
    hash = "sha256-WsUeqkuT4NhoaCJG1hqz+uWyvWQBfxtDheEkWkYmSWU=";
  };

  cargoHash = "sha256-vAMap35rpmEKSHJ9yW/PzPbEWtLw30DawDmI+QfcOsw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
    installShellCompletion --bash sh/completions/shadowenv.bash
    installShellCompletion --fish sh/completions/shadowenv.fish
    installShellCompletion --zsh sh/completions/_shadowenv
  '';

  preCheck = ''
    HOME=$TMPDIR
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "Reversible directory-local environment variable manipulations";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "Reversible directory-local environment variable manipulations";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "shadowenv";
  };
}
