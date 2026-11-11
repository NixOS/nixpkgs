{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wlroots_0_20,
  wayland,
  wayland-protocols,
  wlr-protocols,
  libxkbcommon,
  libinput,
  pixman,
  libdrm,
  libGL,
  lua5_4,
  cairo,
  pango,
  fontconfig,
  adwaita-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shady";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gloaming-dusk";
    repo = "shady";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0NKZkHbJmOeHYLWnxdWylCAO9++9w9Qp8tvWX3KR4Y=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wlroots_0_20
    wayland
    wayland-protocols
    wlr-protocols
    libxkbcommon
    libinput
    pixman
    libdrm
    libGL
    lua5_4
    cairo
    pango
    fontconfig
  ];

  mesonBuildType = "release";
  mesonFlags = [
    (lib.mesonBool "installed_data" true)
    # Provide a fallback cursor theme for systems without one installed.
    (lib.mesonOption "cursor_path" "${adwaita-icon-theme}/share/icons")
  ];

  doCheck = true;

  passthru.providedSessions = [
    "shady"
    "shady-safe"
  ];

  meta = {
    description = "Experimental 3D Wayland compositor";
    homepage = "https://github.com/gloaming-dusk/shady";
    changelog = "https://github.com/gloaming-dusk/shady/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [ jihoo12 ];
    platforms = lib.platforms.linux;
    mainProgram = "shady";
  };
})
