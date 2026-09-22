{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadowenv";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = finalAttrs.version;
    hash = "sha256-1LsOt0+jF00EEDLALXZhrKpLTpoNINgh23OevK0KztM=";
  };

  cargoHash = "sha256-995toHrVVEZ/24ZgEWcgXwz0AFVPdXmylKiEimEBwNQ=";

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
