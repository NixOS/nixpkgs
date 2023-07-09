{ lib
, stdenv
, fetchFromGitea
, fetchpatch
, substituteAll
, swaybg
, sway
, meson
, ninja
, pkg-config
, wayland-scanner
, scdoc
, python3
, wayland
, libxkbcommon
, pcre2
, json_c
, libevdev
, pango
, cairo
, libinput
, gdk-pixbuf
, librsvg
, wlroots_0_16
, wayland-protocols
, libdrm
, nixosTests
# Used by the NixOS module:
, isNixOS ? false
, enableXWayland ? true, xorg
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, trayEnabled ? systemdSupport
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volare-unwrapped";
  version = "1.8.1.0";

  inherit enableXWayland isNixOS systemdSupport trayEnabled;
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "raboof";
    repo = "volare";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s2dUgtmcapANituTBaUGN1mPSIftwbVrpoiJgazq9Lk=";
  };

  patches = [
    ./load-configuration-from-etc.patch

    (substituteAll {
      src = ../sway/fix-paths.patch;
      inherit swaybg;
    })
  ] ++ lib.optionals (!finalAttrs.isNixOS) [
    # References to /nix/store/... will get GC'ed which causes problems when
    # copying the default configuration
    ./volare-config-no-nix-store-references.patch
  ] ++ lib.optionals finalAttrs.isNixOS [
    # Use /run/current-system/sw/share and /etc instead of /nix/store
    # references:
    ../sway/sway-config-nixos-paths.patch
  ];

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson ninja pkg-config wayland-scanner scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre2 json_c libevdev
    pango cairo libinput gdk-pixbuf librsvg
    wayland-protocols libdrm
    (wlroots_0_16.override { inherit (finalAttrs) enableXWayland; })
    sway
  ] ++ lib.optionals finalAttrs.enableXWayland [
    xorg.xcbutilwm
  ];

  mesonFlags = let
    # The "sd-bus-provider" meson option does not include a "none" option,
    # but it is silently ignored iff "-Dtray=disabled".  We use "basu"
    # (which is not in nixpkgs) instead of "none" to alert us if this
    # changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
    # assert trayEnabled -> systemdSupport && dbusSupport;

    sd-bus-provider =  if systemdSupport then "libsystemd" else "basu";
    in
    [ "-Dsd-bus-provider=${sd-bus-provider}" ]
    ++ lib.optional (!finalAttrs.enableXWayland) "-Dxwayland=disabled"
    ++ lib.optional (!finalAttrs.trayEnabled)    "-Dtray=disabled"
  ;

  preInstall = ''
    sed -i "s|#\!/usr/bin/env python3|#\!${python3}/bin/python3|" ../meson_volare_rename.py
  '';

  meta = with lib; {
    description = "A tiling, tabbed wayland compositor (based on Sway)";
    longDescription = ''
      Volare is a tabbed, tiling Wayland compositor.

      It is a fork of sway, but more static: new windows will show up as new
      tabs in the current container instead of rearranging the screen layout.
    '';
    homepage = "https://codeberg.org/raboof/volare";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raboof ];
    mainProgram = "volare";
  };
})
