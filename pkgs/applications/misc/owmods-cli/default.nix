{ lib
, stdenv
, nix-update-script
, fetchFromGitHub
, rustPlatform
, pkg-config
, installShellFiles
, zstd
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "owmods-cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    rev = "cli_v${version}";
    hash = "sha256-k9Jn8LiqDyVmtjKnmpoVePNW2x5UyFfcXAPyvEgUaCU=";
  };

  cargoHash = "sha256-RGJ0vefFkjbAL/y5/q1KMJtkO5bloj9SSebaABWSr/I=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildAndTestSubdir = "owmods_cli";

  postInstall = ''
    cargo xtask dist_cli
    installManPage man/man*/*
    installShellCompletion --cmd owmods \
      dist/cli/completions/owmods.{bash,fish,zsh}
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "CLI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_cli";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    mainProgram = "owmods";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ locochoco ];
  };
}
