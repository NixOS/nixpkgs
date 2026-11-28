{
  lib,
  stdenv,
  rustPackages_1_100,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  bzip2,
  xz,
  zstd,
  installShellFiles,
  versionCheckHook,
}:

rustPackages_1_100.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-binstall";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FlEH6yMvoKyimBvl32bEYd8sBNywCg4ZXcUMZzNZKvU=";
  };

  cargoHash = "sha256-zzaj4wKL3Cw4hhGRM8ASK3KhItkLslPRJ7LMrNY3Naw=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    aws-lc
    bzip2
    xz
    zstd
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "fancy-no-backtrace"
    "git"
    "pkg-config"
    "rustls"
    "trust-dns"
    "zstd-thin"
  ];

  cargoBuildFlags = [
    "-p"
    "cargo-binstall"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-binstall"
  ];

  checkFlags = [
    # requires internet access
    "--skip=download::test::test_and_extract"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_no_such_release"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_v0_20_1"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cargo-binstall \
      --bash <($out/bin/cargo-binstall --completions bash) \
      --fish <($out/bin/cargo-binstall --completions fish) \
      --zsh <($out/bin/cargo-binstall --completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    description = "Tool for installing rust binaries as an alternative to building from source";
    mainProgram = "cargo-binstall";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
})
