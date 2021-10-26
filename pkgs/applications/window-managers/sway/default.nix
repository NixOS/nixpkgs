{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland-scanner, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols, libdrm
, nixosTests
# Used by the NixOS module:
, isNixOS ? false

, enableXWayland ? true
}:

stdenv.mkDerivation rec {
  pname = "sway-unwrapped";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0j4sdbsrlvky1agacc0pcz9bwmaxjmrapjnzscbd2i0cria2fc5j";
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit swaybg;
    })
  ];

  postPatch = lib.optionalString isNixOS ''
    echo -e '\ninclude /etc/sway/config.d/*' >> config.in
  '';

  nativeBuildInputs = [
    meson ninja pkg-config wayland-scanner scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wayland-protocols libdrm
    (wlroots.override { inherit enableXWayland; })
  ];

  mesonFlags = [
    "-Ddefault-wallpaper=false"
    "-Dsd-bus-provider=libsystemd"
  ]
    ++ lib.optional (!enableXWayland) "-Dxwayland=disabled"
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
