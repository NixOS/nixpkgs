{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wayland-scanner
, makeWrapper
, wrapQtAppsHook
, hyprland-protocols
, hyprlang
, libdrm
, mesa
, pipewire
, qtbase
, qttools
, qtwayland
, sdbus-cpp
, systemd
, wayland
, wayland-protocols
, hyprland
, hyprpicker
, slurp
}:
stdenv.mkDerivation (self: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${self.version}";
    hash = "sha256-KsX7sAwkEFpXiwyjt0HGTnnrUU58wW1jlzj5IA/LRz8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    libdrm
    mesa
    pipewire
    qtbase
    qttools
    qtwayland
    sdbus-cpp
    systemd
    wayland
    wayland-protocols
  ];

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgramShell $out/bin/hyprland-share-picker \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH ":" ${lib.makeBinPath [slurp hyprland]}

    wrapProgramShell $out/libexec/xdg-desktop-portal-hyprland \
      --prefix PATH ":" ${lib.makeBinPath [(placeholder "out") hyprpicker]}
  '';

  meta = with lib; {
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    description = "xdg-desktop-portal backend for Hyprland";
    mainProgram = "hyprland-share-picker";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
})
