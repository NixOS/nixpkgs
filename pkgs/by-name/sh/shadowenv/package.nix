{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadowenv";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = finalAttrs.version;
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

  meta = {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "Reversible directory-local environment variable manipulations";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "shadowenv";
  };
})
