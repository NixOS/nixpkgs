{ stdenv
, lib
, gitUpdater
, fetchFromGitea
, pkg-config
, meson
, ninja
, scdoc
, wayland-scanner
, fontconfig
, freetype
, pixman
, libpng
, tllist
, wayland
, wayland-protocols
, dbus
, fcft
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fnott";
  version = "1.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = finalAttrs.version;
    hash = "sha256-KVuBSpf6djf+ceb3LglC/RHAGWS1UAsAT46aPyd2fHQ=";
  };

  PKG_CONFIG_DBUS_1_SESSION_BUS_SERVICES_DIR = "${placeholder "out"}/share/dbus-1/services";

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
    changelog = "https://codeberg.org/dnkl/fnott/src/tag/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Keyboard driven and lightweight Wayland notification daemon for wlroots-based compositors";
    license = with lib.licenses; [ mit zlib ];
    maintainers = with lib.maintainers; [
      jmbaur
      eclairevoyant
    ];
    mainProgram = "fnott";
    platforms = lib.platforms.linux;
  };
})
