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
  version = "0-unstable-2026-06-18";

  src = fetchFromGitLab {
    group = "alasca.cloud";
    owner = "scl";
    repo = "scl-management";
    rev = "bd2d56e3537824537390cb0ba5e9efd4db1410c2";
    hash = "sha256-f/eySU2lq1DwFPZ1CD8P7EeVO8b26Fz6d3PH3OrTm/0=";
  };

  cargoHash = "sha256-aX5HL/zDdrQ+V4vCYZrqlO2vNWuvF4GW2P30jtbv1tE=";

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
