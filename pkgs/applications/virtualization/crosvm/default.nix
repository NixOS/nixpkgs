{ lib, rustPlatform, fetchgit
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "122.1";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "562d81eb28a49ed6e0d771a430c21a458cdd33f9";
    sha256 = "l5sIUInOhhkn3ernQLIEwEpRCyICDH/1k4C/aidy1/I=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-2MaRfQCAjW560sdAPqdWymClwY1U5QjIMzknHry+9zs=";

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
