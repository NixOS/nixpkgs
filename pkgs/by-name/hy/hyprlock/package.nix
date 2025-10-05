{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libxkbcommon,
  hyprgraphics,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  pam,
  sdbus-cpp_2,
  systemdLibs,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  file,
  libjpeg,
  libwebp,
  pango,
  libdrm,
  libgbm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ucJ5C83hJy8XFO8Y+PL9hVcwdrQnj63BjXcO5A4qyNU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
    wayland-scanner
  ];

  buildInputs = [
    cairo
    file
    hyprgraphics
    hyprlang
    hyprutils
    libdrm
    libGL
    libjpeg
    libwebp
    libxkbcommon
    libgbm
    pam
    pango
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  # Install hyprlock config in location upstream looks
  # https://github.com/hyprwm/hyprlock/blob/c976b6a1d135d3743556dc225c80e24918ef1fd5/src/config/ConfigManager.cpp#L185-L191
  # https://github.com/hyprwm/hyprutils/blob/6a8bc9d2a4451df12f5179dc0b1d2d46518a90ab/src/path/Path.cpp#L71-L72
  postInstall = ''
    mkdir -p $out/etc/xdg/hypr
    ln -s $out/share/hypr/hyprlock.conf $out/etc/xdg/hypr/hyprlock.conf
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland's GPU-accelerated screen locking utility";
    homepage = "https://github.com/hyprwm/hyprlock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      iynaix
    ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprlock";
    platforms = lib.platforms.linux;
  };
})
