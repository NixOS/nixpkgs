{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, rustPlatform
, cargo
, desktop-file-utils
, appstream-glib
, blueprint-compiler
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook
, python3
, git
, glib
, gtk4
, gst_all_1
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "4.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
    rev = version;
    hash = "sha256-ohUwxwhPxZlKoP5Nq/daD9z5Nj37C7MnFzyvQKp7R8E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eDwMBxMmj246tplZfREJkViCDbKmuWSUZyM+tChNQDA=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    python3
    git
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "A pomodoro timer for the GNOME desktop";
    maintainers = with maintainers; [ linsui ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
