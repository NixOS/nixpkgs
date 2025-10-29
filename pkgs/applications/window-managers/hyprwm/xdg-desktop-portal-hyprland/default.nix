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
  libgbm,
  pipewire,
  qtbase,
  qttools,
  qtwayland,
  sdbus-cpp_2,
  slurp,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
  debug ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5HXelmz2x/uO26lvW7MudnadbAfoBnve4tRBiDVLtOM=";
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
    libgbm
    pipewire
    qtbase
    qttools
    qtwayland
    sdbus-cpp_2
    systemd
    wayland
    wayland-protocols
    wayland-scanner
  ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;

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
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})
