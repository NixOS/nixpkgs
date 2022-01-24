{ stdenv
, lib
, fetchFromGitLab
, cairo
, dbus
, desktop-file-utils
, gettext
, glib
, gtk3
, libhandy_0
, libsass
, meson
, ninja
, pango
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "contrast";
  version = "0.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    sha256 = "0kk3mv7a6y258109xvgicmsi0lw0rcs00gfyivl5hdz7qh47iccy";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ePkPiWGn79PHrMsSEql5OXZW5uRMdTP+w0/DCcm2KG4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook
    glib # for glib-compile-resources
  ];

  buildInputs = [
    cairo
    dbus
    glib
    gtk3
    libhandy_0
    libsass
    pango
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
  };
}

