{
  lib,
  fetchFromGitHub,
  stdenv,
  systemd,
  meson,
  substituteAll,
  swaybg,
  ninja,
  pkg-config,
  gdk-pixbuf,
  librsvg,
  wayland-protocols,
  libdrm,
  libinput,
  cairo,
  pango,
  wayland,
  libGL,
  libxkbcommon,
  pcre2,
  json_c,
  libevdev,
  scdoc,
  scenefx,
  wayland-scanner,
  xcbutilwm,
  wlroots_0_17,
  testers,
  nixosTests,
  # Used by the NixOS module:
  isNixOS ? false,
  enableXWayland ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  trayEnabled ? systemdSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    enableXWayland
    isNixOS
    systemdSupport
    trayEnabled
    ;

  pname = "swayfx-unwrapped";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "WillPower3309";
    repo = "swayfx";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-VT+JjQPqCIdtaLeSnRiZ3rES0KgDJR7j5Byxr+d6oRg=";
  };

  patches =
    [
      ./load-configuration-from-etc.patch

      (substituteAll {
        src = ./fix-paths.patch;
        inherit swaybg;
      })
    ]
    ++ lib.optionals (!finalAttrs.isNixOS) [
      # References to /nix/store/... will get GC'ed which causes problems when
      # copying the default configuration:
      ./sway-config-no-nix-store-references.patch
    ]
    ++ lib.optionals finalAttrs.isNixOS [
      # Use /run/current-system/sw/share and /etc instead of /nix/store
      # references:
      ./sway-config-nixos-paths.patch
    ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    json_c
    libdrm
    libevdev
    libGL
    libinput
    librsvg
    libxkbcommon
    pango
    pcre2
    scenefx
    wayland
    wayland-protocols
    (wlroots_0_17.override { inherit (finalAttrs) enableXWayland; })
  ] ++ lib.optionals finalAttrs.enableXWayland [ xcbutilwm ];

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
      (mesonEnable "xwayland" finalAttrs.enableXWayland)
      (mesonEnable "tray" finalAttrs.trayEnabled)
    ];

  passthru = {
    tests = {
      basic = nixosTests.swayfx;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "sway --version";
        version = "swayfx version ${finalAttrs.version}";
      };
    };
  };

  meta = {
    description = "Sway, but with eye candy!";
    homepage = "https://github.com/WillPower3309/swayfx";
    changelog = "https://github.com/WillPower3309/swayfx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eclairevoyant
      ricarch97
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sway";

    longDescription = ''
      Fork of Sway, an incredible and one of the most well established Wayland
      compositors, and a drop-in replacement for the i3 window manager for X11.
      SwayFX adds extra options and effects to the original Sway, such as rounded corners,
      shadows and inactive window dimming to bring back some of the Picom X11
      compositor functionality, which was commonly used with the i3 window manager.
    '';
  };
})
