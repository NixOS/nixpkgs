{
  lib,
  writeText,
  rustPlatform,
  fetchFromGitHub,
  curl,
  installShellFiles,
  pkg-config,
  aws-lc,
  bzip2,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  spdx-license-list-data,
  nix,
  nurl,
  versionCheckHook,
  nix-update-script,
}:

let
  get-nix-license = import ./get_nix_license.nix {
    inherit lib writeText;
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-init";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmICSRSOSDgvJxVBOrquQM9zytxDb8hL5wJY8Ea4sCk=";
  };

  cargoHash = "sha256-ZOw+cGVOSLEm+A+1WFf7sYz1qal5jZpU1CMHvKm1fH4=";

  nativeBuildInputs = [
    curl
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    aws-lc
    bzip2
    curl
    libgit2
    openssl
    sqlite
    zlib
    zstd
  ];

  buildNoDefaultFeatures = true;

  checkFlags = [
    # require internet access
    "--skip=e2e"
    "--skip=lang::rust::tests"
  ];

  postPatch = ''
    mkdir -p data
    ln -s ${get-nix-license} data/get_nix_license.rs
  '';

  preBuild = ''
    cargo run -p license-store-cache \
      -j $NIX_BUILD_CORES --frozen \
      data/license-store-cache.zstd ${spdx-license-list-data.json}/json/details
  '';

  postInstall = ''
    installManPage artifacts/nix-init.1
    installShellCompletion artifacts/nix-init.{bash,fish} --zsh artifacts/_nix-init
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
    NIX = lib.getExe nix;
    NURL = lib.getExe nurl;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to generate Nix packages from URLs";
    mainProgram = "nix-init";
    homepage = "https://github.com/nix-community/nix-init";
    changelog = "https://github.com/nix-community/nix-init/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      eclairevoyant
      figsoda
    ];
  };
})
