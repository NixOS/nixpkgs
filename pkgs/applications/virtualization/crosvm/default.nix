{ stdenv, lib, rust, rustPlatform, fetchgit, fetchpatch
, clang, pkg-config, protobuf, python3, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "107.1";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "5a49a836e63aa6e9ae38b80daa09a013a57bfb7f";
    sha256 = "F+5i3R7Tbd9xF63Olnyavzg/hD+8HId1duWm8bvAmLA=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    # Backport seccomp sandbox update for recent Glibc.
    # fetchpatch is not currently gerrit/gitiles-compatible, so we
    # have to use the mirror.
    # https://github.com/NixOS/nixpkgs/pull/133604
    (fetchpatch {
      url = "https://github.com/google/crosvm/commit/aae01416807e7c15270b3d44162610bcd73952ff.patch";
      sha256 = "nQuOMOwBu8QvfwDSuTz64SQhr2dF9qXt2NarbIU55tU=";
    })
  ];

  cargoSha256 = "1jg9x5adz1lbqdwnzld4xg4igzmh90nd9xm287cgkvh5fbmsjfjv";

  nativeBuildInputs = [ clang pkg-config protobuf python3 wayland-scanner ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
    substituteInPlace build.rs --replace '"clang"' '"${stdenv.cc.targetPrefix}clang"'
  '';

  "CARGO_TARGET_${lib.toUpper (builtins.replaceStrings ["-"] ["_"] (rust.toRustTarget stdenv.hostPlatform))}_LINKER" =
    "${stdenv.cc.targetPrefix}cc";

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
