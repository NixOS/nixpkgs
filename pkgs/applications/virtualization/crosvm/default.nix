{ lib, rustPlatform, fetchgit, fetchpatch
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
, pkgsCross
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "125.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "6a7ff1ecb7fad6820d3bbfe8b11e65854059aba5";
    hash = "sha256-y/vHU8i9YNbzSHla853z/2w914mVMFOryyaHE1uxlvM=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "musl.patch";
      url = "https://chromium.googlesource.com/chromiumos/platform/crosvm/+/128e591037c0be0362ed814d0b5583aa65ff09e1%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-p5VzHRb0l0vCJNe48cRl/uBYHwTQMEykMcBOMzL3yaY=";
    })
  ];

  separateDebugInfo = true;

  cargoHash = "sha256-1AUfd9dhIZvVVUsVbnGoLKc0lBfccwM4wqWgU4yZWOE=";

  nativeBuildInputs = [
    pkg-config protobuf python3 rustPlatform.bindgenHook wayland-scanner
  ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
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
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
