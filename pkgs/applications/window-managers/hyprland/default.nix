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
  version = "0.8.1beta";

  # When updating Hyprland, the overridden wlroots commit must be bumped to match the commit upstream uses.
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qyRH3omJmqCnuCSe6//7voGdYBZOLO/BWJt0sXyPztg=";
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

  patches = [
    ./system-wlroots.patch
  ];

  postPatch = ''
    # build with system wlroots
    sed -Ei 's/"\.\.\/wlroots\/include\/([a-zA-Z0-9./_-]+)"/<\1>/g' src/includes.hpp

    # fix hardcoded /usr paths
    substituteInPlace src/render/OpenGL.cpp --replace "/usr" "$out"
  '';

  preConfigure = ''
    make protocols
  '';

  postBuild = ''
    pushd ../hyprctl
    $CXX -std=c++23 -w ./main.cpp -o ./hyprctl
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ./Hyprland $out/bin
    install -m755 ../hyprctl/hyprctl $out/bin

    mkdir -p $out/share/hyprland
    install ../assets/wall_2K.png $out/share/hyprland
    install ../assets/wall_4K.png $out/share/hyprland
    install ../assets/wall_8K.png $out/share/hyprland
  '';

  meta = with lib; {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wozeparrot ];
    mainProgram = "Hyprland";
  };
}
