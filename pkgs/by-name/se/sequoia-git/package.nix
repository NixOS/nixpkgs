{
  lib,
  rustPlatform,
  fetchFromGitLab,
  openssl,
  nettle,
  sqlite,
  pkg-config,
  installShellFiles,
  gnupg,
  gitMinimal,
  libfaketime,
  ...
}:
rustPlatform.buildRustPackage (final: {
  pname = "sequoia-git";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-git";
    rev = "v${final.version}";
    hash = "sha256-1nSFzpz0Rl9uoE59teP3o7PduSmA20QEhe+fvTM6JGA=";
  };

  cargoHash = "sha256-/9/nTqCRi74TMToWQjtnnzQ8en+nqKT8gUipNcHTxvs=";

  buildInputs = [
    openssl.dev
    nettle.dev
    sqlite.dev
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  nativeCheckInputs = [
    gnupg
    gitMinimal
    libfaketime
  ];

  env.ASSET_OUT_DIR = "target";

  postInstall = ''
    installManPage ${final.env.ASSET_OUT_DIR}/man-pages/*.1
    installShellCompletion --bash ${final.env.ASSET_OUT_DIR}/shell-completions/${final.meta.mainProgram}.bash
    installShellCompletion --zsh ${final.env.ASSET_OUT_DIR}/shell-completions/_${final.meta.mainProgram}
    installShellCompletion --fish ${final.env.ASSET_OUT_DIR}/shell-completions/${final.meta.mainProgram}.fish
  '';

  meta = {
    homepage = "https://sequoia-pgp.gitlab.io/sequoia-git";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "sq-git";
  };
})
