{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  scdoc,
  libGL,
  wayland,
  libxkbcommon,
  pcre2,
  json_c,
  libevdev,
  pango,
  cairo,
  libinput,
  gdk-pixbuf,
  librsvg,
  wayland-protocols,
  libdrm,
  evdev-proto,
  nixosTests,
  # Scroll-specific:
  glslang,
  hwdata,
  lua54Packages,
  vulkan-loader,
  xwayland,
  seatd,
  lcms,
  libdisplay-info,
  libxcb-render-util,
  libxcb-errors,
  libliftoff,
  libgbm,
  readline,
  # Used by the NixOS module:
  isNixOS ? false,
  enableXWayland ? true,
  libxcb-wm,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  trayEnabled ? systemdSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scroll-unwrapped";
  version = "1.12.19";

  inherit
    enableXWayland
    isNixOS
    systemdSupport
    trayEnabled
    ;
  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "scroll";
    rev = finalAttrs.version;
    hash = "sha256-SIGDld/pnVULiEH1iOZKz9o1FuqsvF7kEdvSxFxrCAM=";
  };

  patches = [ ];

  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    scdoc

    # Scroll-specific
    glslang
    lcms
    hwdata
    libliftoff
  ];

  buildInputs = [
    libGL
    wayland
    libxkbcommon
    pcre2
    json_c
    libevdev
    pango
    cairo
    libinput
    gdk-pixbuf
    librsvg
    wayland-protocols
    libdrm
    # Scroll uses its own version of wlroots

    # Scroll-specific
    lua54Packages.lua
    vulkan-loader
    seatd
    lcms
    libdisplay-info
    libliftoff
    libgbm
    readline
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    evdev-proto
  ]
  ++ lib.optionals finalAttrs.enableXWayland [
    libxcb-wm
    # Scroll-specific
    xwayland
    libxcb-render-util
    libxcb-errors
  ];

  mesonFlags =
    let
      inherit (lib.strings) mesonEnable mesonOption;

      # The "sd-bus-provider" meson option does not include a "none" option,
      # but it is silently ignored iff "-Dtray=disabled".  We use "basu"
      # (which is not in nixpkgs) instead of "none" to alert us if this
      # changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
      # assert trayEnabled -> systemdSupport && dbusSupport;

      sd-bus-provider = if systemdSupport then "libsystemd" else "basu";
    in
    [
      (mesonOption "sd-bus-provider" sd-bus-provider)
      (mesonEnable "tray" finalAttrs.trayEnabled)
      # Scroll-specific
      (lib.strings.mesonOption "c_args" "-Wno-error=maybe-uninitialized")
    ];

  passthru.tests.basic = nixosTests.scroll;

  meta = {
    description = "Sway fork with a scrolling tiling layout";
    longDescription = ''
      Scroll is a Wayland compositor forked from Sway. The main difference is
      scroll only supports a scrolling layout similar to PaperWM.
      scroll works very similarly to hyprscroller and is mostly compatible with
      Sway configurations aside from the window layout. It adds some features
      such as animations, overview and jump modes, Lua scripting, trails and
      trailmarks or pinning windows.
    '';
    homepage = "https://github.com/dawsers/scroll";
    changelog = "https://github.com/dawsers/scroll/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    maintainers = with lib.maintainers; [ olimoli ];
    mainProgram = "scroll";
  };
})
