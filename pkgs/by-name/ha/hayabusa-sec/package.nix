{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  unstableGitUpdater,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage {
  pname = "hayabusa-sec";
  version = "3.7.0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "Yamato-Security";
    repo = "hayabusa";
    rev = "1c4f332b446f20af154257b2e9b581f7bcb4b1a2";
    hash = "sha256-JWb54yudfB6pOMZca8sFeoRqNA7M//xJ3IBKfIcGBnM=";
    # Include the hayabusa-rules
    fetchSubmodules = true;
  };

  cargoHash = "sha256-JIHkFokaZ+nt1hW+gRxFrb1DVZcm4jsZKT12gx/BRCA=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys # transitive dependency via the hayabusa-evtx crate
  ];

  env.OPENSSL_NO_VENDOR = true;

  # Several checks panic
  # Skipping individual checks causes failure as `--skip` flags
  # end up passed to executing `hayabusa`
  # > error: unexpected argument '--skip' found
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/hayabusa-sec
    cp -r rules $out/share/hayabusa-sec/
    mv $out/bin/hayabusa $out/share/hayabusa-sec/
    makeWrapper $out/share/hayabusa-sec/hayabusa $out/bin/hayabusa
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Sigma-based threat hunting and fast forensics timeline generator for Windows event logs";
    homepage = "https://github.com/Yamato-Security/hayabusa";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      d3vil0p3r
      jk
    ];
    mainProgram = "hayabusa";
  };
}
