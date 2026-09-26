{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pnpm-shell-completion";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "pnpm-shell-completion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lwtRSl0/oqgvFUtCkgExAVTiUt+7PwAD/8ufl+1MIMY=";
  };

  cargoHash = "sha256-/G+wiGlQ1UqH2uWmz55klsu1t6zBrwlv1XH3X+CAPQg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pnpm \
      --fish pnpm.fish \
      --zsh pnpm-shell-completion.plugin.zsh
  '';

  meta = {
    homepage = "https://github.com/g-plane/pnpm-shell-completion";
    description = "Complete your pnpm command fastly";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "pnpm-shell-completion";
  };
})
