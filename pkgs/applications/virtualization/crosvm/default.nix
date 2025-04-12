{
  lib,
  rustPlatform,
  fetchgit,
  fetchpatch,
  pkg-config,
  protobuf,
  python3,
  wayland-scanner,
  libcap,
  libdrm,
  libepoxy,
  minijail,
  virglrenderer,
  wayland,
  wayland-protocols,
  pkgsCross,
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "130.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "9d42f918373f962b7d035ff52a1629e184cb496e";
    hash = "sha256-h8nAZ4kTidblKNvugEEZUorBthjGi0FmImcBwYy4EHQ=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "cross-domain.patch";
      url = "https://chromium.googlesource.com/chromiumos/platform/crosvm/+/60053cdf0b360a03084292b39120365fff65d410%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-U5eOxuAtVLjJ+8h16lmbJYNxsP/AOEv/1ec4WlUxP2E=";
    })
  ];

  separateDebugInfo = true;

  cargoHash = "sha256-FvDJhmrSBShxRTpc23C0jEk9YRbtGyYgC1Z8ekxNnb8=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    python3
    rustPlatform.bindgenHook
    wayland-scanner
  ];

  buildInputs = [
    libcap
    libdrm
    libepoxy
    minijail
    virglrenderer
    wayland
    wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

  CROSVM_USE_SYSTEM_MINIGBM = true;
  CROSVM_USE_SYSTEM_VIRGLRENDERER = true;

  buildFeatures = [ "virgl_renderer" ];

  passthru = {
    updateScript = ./update.py;
    tests = {
      musl = pkgsCross.musl64.crosvm;
    };
  };

  meta = with lib; {
    description = "Secure virtual machine monitor for KVM";
    homepage = "https://crosvm.dev/";
    mainProgram = "crosvm";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
