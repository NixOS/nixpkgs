{
  lib,
  rustPlatform,
  fetchFromGitHub,
  yq,
  pkg-config,
  cmake,
  openssl,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proksi";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "luizfonseca";
    repo = "proksi";
    tag = "proksi-v${finalAttrs.version}";
    hash = "sha256-5IXtMtyKbx7re6CA61AnQ85k/SMdkjZo/ySnNoD2DDo=";
  };

  postPatch = ''
    tomlq -ti 'del(.bench)' crates/proksi/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-yjbtP+FlDaJXPhCu1UyaDolpzy+BUejU8nVVSVsKCzE=";

  nativeBuildInputs = [
    pkg-config
    cmake # required for libz-ng-sys
    yq # for `tomlq`
  ];

  buildInputs = [
    openssl
    zstd
  ];

  cargoBuildFlags = [ "--package=proksi" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  checkFlags = [
    # requires network access
    "--skip=services::discovery::test::test_domain_addr"

    # these tests don't fail themselves, however they invoke clap which tries to parse configuration
    # from the command line, which would normally be empty, but here it includes the `--skip` flags
    # above which clap doesn't recognize and thus rejects
    "--skip=config::tests::"
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=proksi-v(.*)" ]; };

  meta = {
    description = "Batteries-included CDN, reverse proxy and Load Balancer using Cloudflare Pingora";
    homepage = "https://github.com/luizfonseca/proksi";
    changelog = "https://github.com/luizfonseca/proksi/blob/proksi-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "proksi";
  };
})
