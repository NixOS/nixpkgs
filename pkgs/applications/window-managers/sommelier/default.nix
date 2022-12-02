{ lib, stdenv, fetchzip, meson, ninja, pkg-config, wayland-scanner
, libxkbcommon, mesa, pixman, xorg, wayland, gtest
}:

stdenv.mkDerivation {
  pname = "sommelier";
  version = "104.0";

  src = fetchzip rec {
    url = "https://chromium.googlesource.com/chromiumos/platform2/+archive/${passthru.rev}/vm_tools/sommelier.tar.gz";
    passthru.rev = "af5434fd9903936a534e1316cbd22361e67949ec";
    stripRoot = false;
    sha256 = "LungQqHQorHIKpye2SDBLuMHPt45C1cPYcs9o5Hc3cw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ libxkbcommon mesa pixman wayland xorg.libxcb ];

  doCheck = true;
  checkInputs = [ gtest ];

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
