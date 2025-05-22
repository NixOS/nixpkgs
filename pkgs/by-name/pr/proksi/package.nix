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
  version = "0.5.3-unstable-2025-05-12";

  src = fetchFromGitHub {
    owner = "luizfonseca";
    repo = "proksi";
    rev = "da697ae58c515759b710b93ea1d2065a6ae07443";
    hash = "sha256-maoiQc8s+gGC/xqyii/KsYZmF9li8VjyizBqlGq7H0c=";
  };

  postPatch = ''
    tomlq -ti 'del(.bench)' crates/proksi/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-Mmq68jk4EK3J8wnnqznAgcggoFv0iSStlnUwmumRFmQ=";

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
