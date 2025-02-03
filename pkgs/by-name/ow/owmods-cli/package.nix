{ lib
, stdenv
, nix-update-script
, fetchFromGitHub
, rustPlatform
, pkg-config
, installShellFiles
, zstd
, libsoup_3
, makeWrapper
, mono
, wrapWithMono ? true
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "owmods-cli";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    rev = "cli_v${version}";
    hash = "sha256-ONvmTBF9y3NMQx1KgNhJt+0nV57xc9cLalpfDqrTSq0=";
  };

  cargoHash = "sha256-I4OX27LHpT5YYW6yEhX+sCuA8m0KZd/qud4xdEUzkyA=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ] ++ lib.optional wrapWithMono makeWrapper;

  buildInputs = [
    zstd
    libsoup_3
  ] ++ lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildAndTestSubdir = "owmods_cli";

  postInstall = ''
    cargo xtask dist_cli
    installManPage dist/cli/man/*
    installShellCompletion --cmd owmods \
    dist/cli/completions/owmods.{bash,fish,zsh}
    '' + lib.optionalString wrapWithMono ''
    wrapProgram $out/bin/${meta.mainProgram} --prefix PATH : '${mono}/bin'
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "CLI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_cli";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    mainProgram = "owmods";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bwc9876 spoonbaker locochoco ];
  };
}
