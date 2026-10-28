{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  protobuf,
  openssl,
  zlib,
  nix-update-script,
  cloud-utils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "seconlay";
  version = "0-unstable-2026-10-22";

  src = fetchFromGitLab {
    group = "alasca.cloud";
    owner = "scl";
    repo = "scl-management";
    rev = "f4307a2b0614088a6aad73a1444615524be0f847";
    hash = "sha256-6UOLUwiDtwwAZTdVF8m3rgskN1Hk/SH8tWQsz14y2XE=";
  };

  cargoHash = "sha256-njFKZScbr+owYMsqvDwdDnwd4hzxHcPqPoElF0U1u7c=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
    zlib
  ];

  nativeCheckInputs = [ cloud-utils ];
  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Minimal IaaS system with strong tenant separation and small TCB";
    longDescription = ''
      Seconlay (commonly abbreviated as SCL) is a minimal IaaS system built in Rust with strong tenant separation and small TCB.
      It is intended for providing an easy-to-use API to manage a VM-based separation layer underlying to user-facing infrastructure such as tenant-specific Kubernetes clusters.
    '';
    homepage = "https://alasca.cloud/projects/seconlay/";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      malik
      messemar
    ];
    mainProgram = "sclctl";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
