{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alistral";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b6htcjBdh4E9cCUw4ETl3AnmMO3yT6654PLKIGPOPlo=";
  };

  cargoHash = "sha256-Udbf0h8XZ8uD7MLTNRKaIJ8AdTvzq1dDQKPXWXunR/w=";

  buildNoDefaultFeatures = true;
  # Would be cleaner with an "--all-features" option
  buildFeatures = [ "full" ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
    # When invoked in postInstall, alistral tries to write logfiles to its config dir on invocation, and fails if it can't find a writable one.
    # The config dir falls back to a directory relative to $HOME on both Darwin and Linux, so setting a writable $HOME is enough.
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openssl
  ];

  # Wants to create config file where it s not allowed
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd alistral \
      --bash <($out/bin/alistral --generate bash) \
      --fish <($out/bin/alistral --generate fish) \
      --zsh <($out/bin/alistral --generate zsh)
  '';

  meta = {
    homepage = "https://rustynova016.github.io/Alistral/";
    changelog = "https://github.com/RustyNova016/Alistral/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Power tools for Listenbrainz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jopejoe1
      RustyNova
    ];
    mainProgram = "alistral";
  };
})
