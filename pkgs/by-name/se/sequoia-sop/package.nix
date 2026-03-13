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
  version = "0.37.3";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fyItwtzNia97fbLJ1YkpkS7KmCo3I81uksh3lNvxwU=";
  };

  cargoHash = "sha256-NrJYFf2bK/QwfFpIrPD8Zc9N/tKVbN2I48jA2B0rNWk=";

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
