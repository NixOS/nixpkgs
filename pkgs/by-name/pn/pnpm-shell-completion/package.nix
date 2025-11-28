{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "pnpm-shell-completion";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "pnpm-shell-completion";
    rev = "v${version}";
    hash = "sha256-lwtRSl0/oqgvFUtCkgExAVTiUt+7PwAD/8ufl+1MIMY=";
  };

  cargoHash = "sha256-/G+wiGlQ1UqH2uWmz55klsu1t6zBrwlv1XH3X+CAPQg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pnpm \
      --fish pnpm.fish \
      --zsh pnpm-shell-completion.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/g-plane/pnpm-shell-completion";
    description = "Complete your pnpm command fastly";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "pnpm-shell-completion";
  };
}
