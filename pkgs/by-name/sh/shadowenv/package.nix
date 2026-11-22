{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadowenv";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = finalAttrs.version;
    hash = "sha256-j1NfMLFmcKQWue6IYdfTnWWkxET4PahkjBNknOAkLsU=";
  };

  cargoHash = "sha256-fJ12sIYkCfenrh7Bw/xOsLT8chABTwaICr6mXt0UGF0=";

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
