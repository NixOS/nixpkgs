{ lib, stdenv, fetchzip, meson, ninja, pkg-config, wayland-scanner
, libxkbcommon, mesa, pixman, xorg, wayland, gtest
}:

stdenv.mkDerivation {
  pname = "sommelier";
  version = "112.0";

  src = fetchzip rec {
    url = "https://chromium.googlesource.com/chromiumos/platform2/+archive/${passthru.rev}/vm_tools/sommelier.tar.gz";
    passthru.rev = "72325ef016c465c332896c86f01f0eec6616d31b";
    stripRoot = false;
    sha256 = "aSyl1tcPUf+xt/Gy/WwjE+wsth+lih76se2EKWD4+cM=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ libxkbcommon mesa pixman wayland xorg.libxcb ];

  doCheck = true;
  nativeCheckInputs = [ gtest ];

  postInstall = ''
    rm $out/bin/sommelier_test # why does it install the test binary? o_O
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    homepage = "https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/main/vm_tools/sommelier/";
    description = "Nested Wayland compositor with support for X11 forwarding";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
