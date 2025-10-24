{
  lib,
  fetchpatch2,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  xz,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binstall";
  version = "1.15.8";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
    hash = "sha256-Veus7CAjnmBwHFL9/AS0EJe362HhenKBaETwwLNLn68=";
  };

  cargoPatches = [
    (fetchpatch2 {
      name = "CVE-2025-62518-fix";
      url = "https://github.com/cargo-bins/cargo-binstall/commit/f79baa6f399256d19c79efb8e885ae5b3e2e6482.patch?full_index=1";
      hash = "sha256-keXPZl2jOw6bKRL8Rjn97slcf4a3fIeUcQmbHIzHt/o=";
    })
  ];

  cargoHash = "sha256-Z2EOuJNdXkTBJ2Vzux5TZrxdggVaOD23pqiUsnt3AbQ=";

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
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
