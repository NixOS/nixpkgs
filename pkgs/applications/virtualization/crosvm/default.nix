{ lib, rustPlatform, fetchgit
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
, pkgsCross
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "127.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "8fdfed12c960850e9d5e809cfd2a40ce3bdd98d6";
    hash = "sha256-W0zLYM91xoq9vURgYs2noc9F9RtvoXztIIHMx0HVK5g=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-nEJBRlwMqTahaIC9WdtoxGLVfc+U9sJ0ilzLhavcbD0=";

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
