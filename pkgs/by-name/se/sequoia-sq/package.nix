{
  stdenv,
  fetchFromGitLab,
  lib,
  darwin,
  nettle,
  nix-update-script,
  rustPlatform,
  pkg-config,
  capnproto,
  installShellFiles,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sq";
  version = "aed58003b081dadf660642a62a8dcf708967aeca";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    rev = "${version}";
    hash = "sha256-IBA2POfM7BMOxjUU0oIN5B/o3b0/z7kuEjpu+DwJyFk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tATxGaoF/+cUDywvlnW1N2sKo/FbKhJM7yUb74mxB5s=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    capnproto
    installShellFiles
  ];

  buildInputs =
    [
      openssl
      sqlite
      nettle
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  # Needed for tests to be able to create a ~/.local/share/sequoia directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  env.ASSET_OUT_DIR = "/tmp/";
  env.RUST_BACKTRACE = "full";

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
    description = "A command line application exposing a useful set of OpenPGP functionality for common tasks.";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${version}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      minijackson
      doronbehar
      dvn0
    ];
    mainProgram = "sq";
  };
}
