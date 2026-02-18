{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  xz,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-binstall";
  version = "1.17.5";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uYHaVNRq8iTeDs/EW5f5wp/fNBicNYzab4PgEHuY814=";
  };

  cargoHash = "sha256-IFYY3bSqm2OfbjmIHXbc0vIRhiw6Wwss8Sa3fx5s1Pk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
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
