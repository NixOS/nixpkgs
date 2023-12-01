{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, libinput
, gnome
, gnome-desktop
, glib
, gtk3
, wayland
, libdrm
, libxkbcommon
, wlroots
, xorg
, nixosTests
}:

let
  phocWlroots = wlroots.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      # Revert "layer-shell: error on 0 dimension without anchors"
      # https://source.puri.sm/Librem5/phosh/-/issues/422
      (fetchpatch {
        name = "0001-Revert-layer-shell-error-on-0-dimension-without-anch.patch";
        url = "https://gitlab.gnome.org/World/Phosh/phoc/-/raw/acb17171267ae0934f122af294d628ad68b09f88/subprojects/packagefiles/wlroots/0001-Revert-layer-shell-error-on-0-dimension-without-anch.patch";
        hash = "sha256-uNJaYwkZImkzNUEqyLCggbXAoIRX5h2eJaGbSHj1B+o=";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "phoc";
  version = "0.31.0";

  src = fetchurl {
    # This tarball includes the meson wrapped subproject 'gmobile'.
    url = "https://storage.puri.sm/releases/phoc/phoc-${version}.tar.xz";
    hash = "sha256-P7Bs9JMv6KNKo4d2ID0/Ba4+Nel6DMn8o4I7EDvY4vY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome-desktop
    # For keybindings settings schemas
    gnome.mutter
    wayland
    phocWlroots
    xorg.xcbutilwm
  ];

  mesonFlags = ["-Dembed-wlroots=disabled"];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  passthru.tests.phosh = nixosTests.phosh;

  meta = with lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    homepage = "https://gitlab.gnome.org/World/Phosh/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat tomfitzhenry zhaofengli ];
    platforms = platforms.linux;
  };
}
