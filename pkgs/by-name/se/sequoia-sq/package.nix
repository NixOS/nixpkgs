{
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.34.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    rev = "v${version}";
    hash = "sha256-voFektWZnkmIQzI7s5nKzVVWQtEhzk2GKtxX926RtxU=";
  };
  patches = [
    # Fixes test failing on Darwin, see:
    # https://gitlab.com/sequoia-pgp/sequoia-sq/-/issues/211
    (fetchpatch {
      url = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/commit/21221a935e0d058ed269ae6c8f45c5fa7ea0d598.patch";
      hash = "sha256-ZjTl3EumeFwMJUl+qMpX+P2maYz4Ow/Tn9KwYbHDbes=";
    })
  ];

  cargoHash = "sha256-3ncBpRi0v6g6wwPkSASDwt0d8cOOAUv9BwZaYvnif1U=";

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
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  # Sometimes, tests fail on CI (ofborg) & hydra without this
  checkFlags = [
    # doctest for sequoia-ipc fail for some reason
    "--skip=macros::assert_send_and_sync"
    "--skip=macros::time_it"
  ];

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

  meta = with lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      minijackson
      doronbehar
    ];
    mainProgram = "sq";
  };
}
