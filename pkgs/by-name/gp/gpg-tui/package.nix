{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  gpgme,
  libgpg-error,
  libxcb,
  libxkbcommon,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpg-tui";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qGm0eHpVFGn8tNdEnmQ4oIfjCxyixMFYdxih7pHvGH0=";
  };

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      gpgme
      libgpg-error
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libxcb
      libxkbcommon
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ];

  # tests require gpg-agent with a running keyring
  doCheck = false;

  postInstall = ''
    installManPage man/gpg-tui.1 man/gpg-tui.toml.5

    mkdir -p completions
    OUT_DIR=completions $out/bin/gpg-tui-completions
    installShellCompletion \
      completions/gpg-tui.{bash,fish} \
      --zsh completions/_gpg-tui

    rm -f $out/bin/gpg-tui-completions
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage your GnuPG keys with ease!";
    homepage = "https://github.com/orhun/gpg-tui";
    changelog = "https://github.com/orhun/gpg-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gpg-tui";
    platforms = lib.platforms.unix;
  };
})
