{ lib, rustPlatform, fetchgit, fetchpatch
, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "120.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "0a9d1cb8be29e49c355ea8b18cd58506dbbaf6e5";
    sha256 = "BbCcsxJU25VgWVday4rGPXaJSuAWebNGo3MiYPIBBto=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "test-page-size-fix.patch";
      url = "https://chromium.googlesource.com/crosvm/crosvm/+/d9bc6e99ff5ac31d7d88b684c938af01a0872fc1%5E%21/?format=TEXT";
      decode = "base64 -d";
      includes = [ "src/crosvm/config.rs" ];
      hash = "sha256-3gfNzp0WhtNr+8CWSISCJau208EMIo3RJhM+4SyeV3o=";
    })
  ];

  separateDebugInfo = true;

  cargoHash = "sha256-YXfKZeRL3gfWztf36lVNbCCwUqW+0w3q7X7v0arCrvk=";

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
