{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, makeWrapper
, wrapQtAppsHook
, hyprland-protocols
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
, slurp
}:
stdenv.mkDerivation (self: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${self.version}";
    hash = "sha256-VRr5Xc4S/VPr/gU3fiOD3vSIL2+GJ+LUrmFTWTwnTz4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    hyprland-protocols
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
      --prefix PATH ":" ${lib.makeBinPath [(placeholder "out")]}
  '';

  meta = with lib; {
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    description = "xdg-desktop-portal backend for Hyprland";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
})
