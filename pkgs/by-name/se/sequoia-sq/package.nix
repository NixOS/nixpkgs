{
  fetchFromGitLab,
  lib,
  nettle,
  nix-update-script,
  rustPlatform,
  pkg-config,
  capnproto,
  installShellFiles,
  openssl,
  cacert,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-sq";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lM+j1KtH3U/lbPXnKALAP75YokDufbdz8s8bjb0VXUY=";
  };

  cargoHash = "sha256-3z1Qm/eeVlH0/x3C8PSSPIlQaRKk1U6mRlEiKk0AaVQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    capnproto
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
    nettle
  ];

  # Needed for tests to be able to create a ~/.local/share/sequoia directory
  # Needed for avoiding "OpenSSL error" since 1.2.0
  preCheck = ''
    export HOME=$(mktemp -d)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  env.ASSET_OUT_DIR = "/tmp/";

  doCheck = true;

  postInstall = ''
    installManPage /tmp/man-pages/*.*
    installShellCompletion \
      --cmd sq \
      --bash /tmp/shell-completions/sq.bash \
      --fish /tmp/shell-completions/sq.fish \
      --zsh /tmp/shell-completions/_sq
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line application exposing a useful set of OpenPGP functionality for common tasks";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      minijackson
      doronbehar
      dvn0
    ];
    mainProgram = "sq";
  };
})
