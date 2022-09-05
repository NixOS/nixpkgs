{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, rustPlatform
, pkg-config
, glib
, gtk4
, gtksourceview5
, libadwaita
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, libsecret
, desktop-file-utils
, appstream-glib
, openssl
, pipewire
, libshumate
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "fractal-next";
  version = "unstable-2022-07-21";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = "d076bd24419ac6172c2c1a7cc023a5dca938ef07";
    hash = "sha256-2bS6PZuMbR/VgSpMD31sQR4ZkhWNu1CLSl6MX0f/m5A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-CJD9YmL06ELR3X/gIrsVCpDyJnWPbH/JF4HlXvWjiZ8=";
  };

  nativeBuildInputs = [
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gtk4
    gtksourceview5
    libadwaita
    libsecret
    openssl
    pipewire
    libshumate
  ];

  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
  };
}
