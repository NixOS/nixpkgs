{
  lib,
  stdenv,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  python3,
  python3Packages,
  wayland-scanner,
  libxkbcommon,
  libgbm,
  pixman,
  xorg,
  wayland,
  gtest,
}:

stdenv.mkDerivation {
  pname = "sommelier";
  version = "138.0";

  src = fetchzip rec {
    url = "https://chromium.googlesource.com/chromiumos/platform2/+archive/${passthru.rev}/vm_tools/sommelier.tar.gz";
    passthru.rev = "85a947e4c5cf8cb006e9db619484db11b567f0fe";
    stripRoot = false;
    sha256 = "r75LHH1PRa2uhIUviE1MjD/m3HxyeDz9iVuZ/MHEXgk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    wayland-scanner
  ];
  buildInputs = [
    libxkbcommon
    libgbm
    pixman
    wayland
    xorg.libxcb
  ];

  preConfigure = ''
    patchShebangs gen-shim.py
  '';

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
    mainProgram = "sommelier";
  };
}
