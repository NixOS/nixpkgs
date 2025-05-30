{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "shadowenv";
    rev = version;
    hash = "sha256-ZipFcwTpKKFnQWOPxXg07V71jitG0NSLpGLEzUSsUFA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KNCucBmYVmIQ/XY+UNV667iWLyiEJDnP/8gAmUHGY+0=";

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

  meta = with lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "shadowenv";
  };
}
