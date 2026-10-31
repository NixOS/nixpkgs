{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadowenv";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = finalAttrs.version;
    hash = "sha256-I0Bd/c4EUBlfz6zyaoc2IPRS4oDijw5SAt81o/fb9WY=";
  };

  cargoHash = "sha256-oV8Tkp6PxzrBK4LB2II4GzjrpSN1Z4ku1nt/IzRvS08=";

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
