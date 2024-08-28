{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wayland-scanner,
  makeWrapper,
  wrapQtAppsHook,
  nix-update-script,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cyyxu/oj4QEFp3CVx2WeXa9T4OAUyynuBJHGkBZSxJI=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    changelog = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/releases/tag/v${finalAttrs.version}";
    mainProgram = "hyprland-share-picker";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
})
