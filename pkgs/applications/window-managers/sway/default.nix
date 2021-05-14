{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland, scdoc
, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols, libdrm
, nixosTests
# Used by the NixOS module:
, isNixOS ? false
}:

stdenv.mkDerivation rec {
  pname = "sway-unwrapped";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0vnplva11yafhbijrk68wy7pw0psn9jm0caaymswq1s951xsn1c8";
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

  nativeBuildInputs = [
    meson ninja pkg-config wayland scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wlroots wayland-protocols libdrm
  ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

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
