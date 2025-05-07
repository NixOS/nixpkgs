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
  version = "0.5.3-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "luizfonseca";
    repo = "proksi";
    rev = "d0d95bd0bc142fafbe095248597a057524ff0721";
    hash = "sha256-D+MS7Y7aKlgAY7T2vq+rayZ8fjP+98gGJrF5qLvH37Q=";
  };

  postPatch = ''
    tomlq -ti 'del(.bench)' crates/proksi/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-HEwtaERPw6llwhXPgifrtuO1fjV1gCEuH80PaIukp6Q=";

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
  # remove after updating to the next stable version
  preVersionCheck = ''
    export version=0.5.3
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=proksi-v(.*)"
    ];
  };

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
