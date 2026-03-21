{
  lib,
  writeText,
  rustPlatform,
  fetchFromGitHub,
  curl,
  installShellFiles,
  pkg-config,
  bzip2,
  libgit2,
  openssl,
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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tjVdiKaa6mGIkjvG6NYnKef9VBJS26FXHGjZ+Zxb0s0=";
  };

  cargoHash = "sha256-PUD3c/YnxYCVf/4C++MWxejHsLSS1ysWwiTRZVOp8Vc=";

  nativeBuildInputs = [
    curl
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    bzip2
    curl
    libgit2
    openssl
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
    LIBGIT2_NO_VENDOR = true;
    NIX = lib.getExe nix;
    NURL = lib.getExe nurl;
    ZSTD_SYS_USE_PKG_CONFIG = true;
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
