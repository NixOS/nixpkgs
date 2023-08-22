{ lib, rustPlatform, fetchgit, fetchpatch
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "115.2";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "d14053a211eb6753c53ced71fad2d3b402b997e6";
    sha256 = "8p6M9Q9E07zqtHYdIIi6io9LLatd+9fH4Inod2Xjy5M=";
    fetchSubmodules = true;
  };

  patches = [
    # Backport option to not vendor virglrenderer.
    (fetchpatch {
      url = "https://chromium.googlesource.com/crosvm/crosvm/+/dde9aa0e6d89a090f5d5f000822f7911eba98445%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-W/s1i2reBXsbr0AOEtL9go3TNNYMwDVEu6pz3Q9wBSU=";
    })
  ];

  separateDebugInfo = true;

  cargoSha256 = "ZXyMeu2forItGcsGrNBWhV1V9HzVQK6LM4TxBrxAZnU=";

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
    homepage = "https://chromium.googlesource.com/crosvm/crosvm/";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
