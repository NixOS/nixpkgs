{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook
, gdk-pixbuf
, glib
, gst_all_1
, gtk4
, libadwaita
, openssl
, sqlite
, wayland
, zbar
}:

stdenv.mkDerivation rec {
  pname = "authenticator";
  version = "4.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    rev = version;
    sha256 = "0fvs76f3fm5pxn7wg6sjbqpgip5w2j7xrh4siasdcl2bx6vsld8b";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1s97jyszxf24rs3ni11phiyvmp1wm8sicb0rh1jgwz4bn1cnakx4";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    # gst-plugins-good needs gtk4 support:
    # https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/-/merge_requests/767
    # We copy the way it is built from the Flatpak:
    # https://gitlab.gnome.org/World/Authenticator/-/blob/master/build-aux/com.belmoussaoui.Authenticator.Devel.json
    (gst_all_1.gst-plugins-good.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        "${src}/build-aux/767.patch"
      ];
      mesonFlags = old.mesonFlags ++ [
        "-Dgtk3=disabled"
        "-Dgtk4=enabled"
        "-Dgtk4-experiments=true"
      ];
      buildInputs = old.buildInputs ++ [
        gtk4
      ];
    }))

    (gst_all_1.gst-plugins-bad.override { enableZbar = true; })
    gtk4
    libadwaita
    openssl
    sqlite
    wayland
    zbar
  ];

  meta = with lib; {
    broken = true; # https://gitlab.gnome.org/World/Authenticator/-/issues/271
    description = "Two-factor authentication code generator for GNOME";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
