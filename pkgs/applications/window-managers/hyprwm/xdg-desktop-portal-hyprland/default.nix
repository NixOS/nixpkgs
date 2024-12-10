{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  makeWrapper,
  wrapQtAppsHook,
  hyprland-protocols,
  hyprlang,
  libdrm,
  mesa,
  pipewire,
  qtbase,
  qttools,
  qtwayland,
  sdbus-cpp,
  systemd,
  wayland,
  wayland-protocols,
  hyprland,
  hyprpicker,
  slurp,
}:
stdenv.mkDerivation (self: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${self.version}";
    hash = "sha256-wP611tGIWBA4IXShWbah7TxqdbvhfcfT2vnXalX/qzk=";
  };

  patches = [
    # Fixes a long-standing RCE vulnerability (hyprwm/xdg-desktop-portal-hyprland#242)
    # Can be removed after v1.3.3
    (fetchpatch {
      url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/84a9cdca3adcf1cb288c2d38f8c6fc1835a3ae23.patch";
      hash = "sha256-rdu+8KDa1o125GZKTYquZfS8JG05odlzDzz8QxRoQYk=";
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
      --prefix PATH ":" ${
        lib.makeBinPath [
          slurp
          hyprland
        ]
      }

    wrapProgramShell $out/libexec/xdg-desktop-portal-hyprland \
      --prefix PATH ":" ${
        lib.makeBinPath [
          (placeholder "out")
          hyprpicker
        ]
      }
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
