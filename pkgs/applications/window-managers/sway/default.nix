{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland-scanner, scdoc
, wayland, libxkbcommon, pcre, json_c, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols, libdrm
, nixosTests
# Used by the NixOS module:
, isNixOS ? false

, enableXWayland ? true
, systemdSupport ? stdenv.isLinux
, dbusSupport ? true
, dbus
, trayEnabled ? systemdSupport && dbusSupport
}:

# The "sd-bus-provider" meson option does not include a "none" option,
# but it is silently ignored iff "-Dtray=disabled".  We use "basu"
# (which is not in nixpkgs) instead of "none" to alert us if this
# changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
assert trayEnabled -> systemdSupport && dbusSupport;
let sd-bus-provider = if systemdSupport then "libsystemd" else "basu"; in

stdenv.mkDerivation rec {
  pname = "sway-unwrapped";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0ss3l258blyf2d0lwd7pi7ga1fxfj8pxhag058k7cmjhs3y30y5l";
  };

  patches = [
    ./load-configuration-from-etc.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit swaybg;
    })
  ] ++ lib.optionals (!isNixOS) [
    # References to /nix/store/... will get GC'ed which causes problems when
    # copying the default configuration:
    ./sway-config-no-nix-store-references.patch
  ] ++ lib.optionals isNixOS [
    # Use /run/current-system/sw/share and /etc instead of /nix/store
    # references:
    ./sway-config-nixos-paths.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson ninja pkg-config wayland-scanner scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wayland-protocols libdrm
    (wlroots.override { inherit enableXWayland; })
  ] ++ lib.optionals dbusSupport [
    dbus
  ];

  mesonFlags =
    [ "-Dsd-bus-provider=${sd-bus-provider}" ]
    ++ lib.optional (!enableXWayland) "-Dxwayland=disabled"
    ++ lib.optional (!trayEnabled)    "-Dtray=disabled"
  ;

  passthru.tests.basic = nixosTests.sway;

  meta = with lib; {
    description = "An i3-compatible tiling Wayland compositor";
    longDescription = ''
      Sway is a tiling Wayland compositor and a drop-in replacement for the i3
      window manager for X11. It works with your existing i3 configuration and
      supports most of i3's features, plus a few extras.
      Sway allows you to arrange your application windows logically, rather
      than spatially. Windows are arranged into a grid by default which
      maximizes the efficiency of your screen and can be quickly manipulated
      using only the keyboard.
    '';
    homepage    = "https://swaywm.org";
    changelog   = "https://github.com/swaywm/sway/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ma27 ];
  };
}
