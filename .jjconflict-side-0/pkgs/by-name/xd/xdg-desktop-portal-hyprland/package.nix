{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  nix-update-script,
  aquamarine,
  cairo,
  grim,
  hyprgraphics,
  hyprland-protocols,
  hyprlang,
  hyprtoolkit,
  hyprutils,
  hyprwayland-scanner,
  libdrm,
  libgbm,
  libuuid,
  pipewire,
  sdbus-cpp_2,
  slurp,
  wayland,
  wayland-protocols,
  wayland-scanner,
  debug ? false,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uyd3OAvtB2TJ9Y1RooCyLr6dlFUZKDmac5QtMbbPq4c=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    aquamarine
    cairo
    hyprgraphics
    hyprland-protocols
    hyprlang
    hyprtoolkit
    hyprutils
    libdrm
    libgbm
    libuuid
    pipewire
    sdbus-cpp_2
    wayland
    wayland-protocols
    wayland-scanner
  ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;
  separateDebugInfo = !debug;

  doCheck = true;

  postInstall = ''
    wrapProgramShell $out/bin/hyprland-share-picker \
      --prefix PATH ":" ${lib.makeBinPath [ slurp ]}

    wrapProgramShell $out/libexec/xdg-desktop-portal-hyprland \
      --prefix PATH ":" ${
        lib.makeBinPath [
          (placeholder "out")
          grim
          slurp
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
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})
