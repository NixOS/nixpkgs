{
  lib,
  fetchFromGitLab,
  nettle,
  nix-update-script,
  installShellFiles,
  rustPlatform,
  sqlite,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-sop";
  version = "0.38.0-pqc.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TqTVkiEAgdTJQp6f7ygujPKK3CbRaiwdMHbXywqYm9U=";
  };

  cargoHash = "sha256-O9NvGWjrfYIy0tV9CU70sFkrIn9CpasN1gX9SF2cfXk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
    sqlite
  ];

  buildFeatures = [ "cli" ];

  env.ASSET_OUT_DIR = "/tmp/";

  # Install manual pages
  postInstall = ''
    installManPage /tmp/man-pages/*.*
    installShellCompletion --cmd sqop \
      --bash /tmp/shell-completions/sqop.bash \
      --fish /tmp/shell-completions/sqop.fish \
      --zsh /tmp/shell-completions/_sqop
    # Also elv and powershell are generated there
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Stateless OpenPGP Command Line Interface using Sequoia";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-sop";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sop/-/blob/v${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "sqop";
  };
})
