{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "pnpm-shell-completion";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "pnpm-shell-completion";
    rev = "v${version}";
    hash = "sha256-UKuAUN1uGNy/1Fm4vXaTWBClHgda+Vns9C4ugfHm+0s=";
  };

  cargoHash = "sha256-Kf28hQ5PUHeH5ZSRSRdfHljlqIYU8MN0zQsyT0Sa2+4=";

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
