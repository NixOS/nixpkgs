{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gpgme,
  libgpg-error,
  pkg-config,
  python3,
  libiconv,
  darwin,
  x11Support ? true,
  libxcb,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpg-tui";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DTVtMwKAZjPwT6c7FYoaT12Axoz3j1cMFKjDDsaHyjk=";
  };

  cargoHash = "sha256-d2PYJajDKukwDERSjQcPSJaYbZDftNLBYEXq+7ZdlKw=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    pkg-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpg-error
  ]
  ++ lib.optionals x11Support [
    libxcb
    libxkbcommon
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    darwin.libresolv
  ];

  meta = {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    changelog = "https://github.com/orhun/gpg-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      matthiasbeyer
    ];
    mainProgram = "gpg-tui";
  };
})
