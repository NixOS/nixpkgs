{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  wrapQtAppsHook,
  nix-update-script,
  hyprland,
  hyprland-protocols,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  libdrm,
  mesa,
  pipewire,
  qtbase,
  qttools,
  qtwayland,
  sdbus-cpp,
  slurp,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-xTqnMoJsEojuvqJLuM+U7EZ7q71efaj3pbvjutq4TXc=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wrapQtAppsHook
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    hyprutils
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
    wayland-scanner
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
      --prefix PATH ":" ${lib.makeBinPath [ (placeholder "out") ]}
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
