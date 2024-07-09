{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # TODO: remove on next upgrade
    (fetchpatch {
      name = "fix-compilation-pipewire-1.2.0.patch";
      url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/c5b30938710d6c599f3f5cd99a3ffac35381fb0f.patch";
      hash = "sha256-f9OgW9tLuGuHXYH6bR1Y+CEuBPHOhRiHfEPebJzlwK8=";
    })
  ];

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
