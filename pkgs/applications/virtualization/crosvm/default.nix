{ lib, rustPlatform, fetchgit
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "121.3";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "1e7125327a29b7b7a0593caf339d382728c55cf6";
    sha256 = "Rjs46TtOhFZxqnEyqa4IyrRs7HnDZ/DJZ9DPEe7Oux0=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-7nfeg/q8baLvB0CoRWKU60TRfLAaRkeRxGojPvKpOLs=";

  nativeBuildInputs = [
    pkg-config protobuf python3 rustPlatform.bindgenHook wayland-scanner
  ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

  CROSVM_USE_SYSTEM_VIRGLRENDERER = true;

  buildFeatures = [ "default" "virgl_renderer" "virgl_renderer_next" ];

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "A secure virtual machine monitor for KVM";
    homepage = "https://crosvm.dev/";
    mainProgram = "crosvm";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
