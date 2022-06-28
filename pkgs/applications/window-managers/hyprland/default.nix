{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libdrm
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "hyprland";
  version = "0.6.1beta";

  # When updating Hyprland, the overridden wlroots commit must be bumped to match the commit upstream uses.
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0Msqe2ErAJvnO1zHoB2k6TkDhTYnHRGkvJrfSG12dTU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libdrm
    libinput
    libxcb
    libxkbcommon
    mesa
    pango
    wayland
    wayland-protocols
    wlroots
    xcbutilwm
  ];

  # build with system wlroots
  postPatch = ''
    sed -Ei 's/"\.\.\/wlroots\/include\/([a-zA-Z0-9./_-]+)"/<\1>/g' src/includes.hpp
  '';

  preConfigure = ''
    make protocols
  '';

  postBuild = ''
    pushd ../hyprctl
    $CXX -std=c++20 -w ./main.cpp -o ./hyprctl
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ./Hyprland $out/bin
    install -m755 ../hyprctl/hyprctl $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/vaxerski/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wozeparrot ];
    mainProgram = "Hyprland";
  };
}
