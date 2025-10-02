{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "pnpm-shell-completion";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "pnpm-shell-completion";
    rev = "v${version}";
    hash = "sha256-bc2ZVHQF+lSAmhy/fvdiVfg9uzPPcXYrtiNChjkjHtA=";
  };

  cargoHash = "sha256-JL9bWVHmdSktOEF70WMOmZKdZwO/gNDp0GPDMYteR1E=";

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
