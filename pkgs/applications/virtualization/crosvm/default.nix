{ lib, rustPlatform, fetchgit, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "113.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "f2871094c45bc3a8a2604cbba5b34da27d676af7";
    sha256 = "seeqr453Qjk1MoYq2ZlPsgUOMaV7PbK4MKze2cl2NvI=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoSha256 = "hGhYzynNvsaSQO2lSEh/OGWkeE8bEinwb0QxX87TQU0=";

  nativeBuildInputs = [
    pkg-config protobuf python3 rustPlatform.bindgenHook wayland-scanner
  ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

  # crosvm mistakenly expects the stable protocols to be in the root
  # of the pkgdatadir path, rather than under the "stable"
  # subdirectory.
  PKG_CONFIG_WAYLAND_PROTOCOLS_PKGDATADIR =
    "${wayland-protocols}/share/wayland-protocols/stable";

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
