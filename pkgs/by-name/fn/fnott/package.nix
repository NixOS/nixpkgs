{
  stdenv,
  lib,
  gitUpdater,
  fetchFromGitea,
  pkg-config,
  meson,
  ninja,
  scdoc,
  wayland-scanner,
  fontconfig,
  freetype,
  pixman,
  libpng,
  tllist,
  wayland,
  wayland-protocols,
  dbus,
  fcft,
}:

stdenv.mkDerivation rec {
  pname = "fnott";
  version = "1.5.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = version;
    hash = "sha256-F2Pt3xbWDZZ3s056KU3qLXUrFQ0wT7QYK4GvR7slMYc=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    freetype
    pixman
    libpng
    tllist
    wayland
    wayland-protocols
    dbus
    fcft
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://codeberg.org/dnkl/fnott";
    description = "Keyboard driven and lightweight Wayland notification daemon for wlroots-based compositors";
    license = with lib.licenses; [
      mit
      zlib
    ];
    maintainers = with lib.maintainers; [ polykernel ];
    mainProgram = "fnott";
    platforms = lib.platforms.linux;
  };
}
