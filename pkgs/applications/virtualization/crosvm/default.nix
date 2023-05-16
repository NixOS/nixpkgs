{ lib, rustPlatform, fetchgit, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
<<<<<<< HEAD
  version = "116.1";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "97ac6ce38d8e5789c91fcc5bae6078d21a2afdb3";
    sha256 = "NssjHXorPGZBYqERPeLW3cqEzbXqyL9N4OnLLQMLALk=";
=======
  version = "112.0";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "014b853ebdba00c7bad751a37fa4271ff2a50d77";
    sha256 = "qVfkNN6dHfMeDYMDvccU9PAz78Dh2ylL6UpoApoYKJw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

<<<<<<< HEAD
  cargoHash = "sha256-mlXAlq62nAW6ZVxRav+k/iU1YDecfPDTCPp7FdJBO54=";
=======
  cargoSha256 = "ath0x9dfQCWWU9+zKyYLC6Q/QXupifHhdQxrS+N2UWw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config protobuf python3 rustPlatform.bindgenHook wayland-scanner
  ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

<<<<<<< HEAD
  CROSVM_USE_SYSTEM_VIRGLRENDERER = true;
=======
  # crosvm mistakenly expects the stable protocols to be in the root
  # of the pkgdatadir path, rather than under the "stable"
  # subdirectory.
  PKG_CONFIG_WAYLAND_PROTOCOLS_PKGDATADIR =
    "${wayland-protocols}/share/wayland-protocols/stable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
