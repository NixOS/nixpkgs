{ lib, rustPlatform, fetchgit, fetchpatch
, pkg-config, protobuf, python3, wayland-scanner, dbus, libva, libX11, libXext, mesa, ffmpeg
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "unstable-2024-01-02";

  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "dbdd15966d6bb8239f33d31a658221cac47e3666";
    sha256 = "sha256-UyGzimfksHdMMI3bzmctLqQqWRo5WVj04t+ElcX32Tg=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-hTJFrqFzoARugKvXuCxLhuXDJEkWzNe8uAl2EtISE4k=";

  nativeBuildInputs = [
    pkg-config protobuf python3 rustPlatform.bindgenHook wayland-scanner
  ];

  buildInputs = [
    dbus
    ffmpeg
    libcap
    libdrm
    libepoxy
    libva
    libX11
    libXext
    mesa
    minijail
    virglrenderer
    wayland
    wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

  env.CROSVM_USE_SYSTEM_VIRGLRENDERER = "1";
  env.CROSVM_USE_SYSTEM_MINIGBM = "1";

  buildFeatures = [ "all-default" ];

  meta = with lib; {
    description = "A secure virtual machine monitor for KVM";
    homepage = "https://crosvm.dev/";
    mainProgram = "crosvm";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
