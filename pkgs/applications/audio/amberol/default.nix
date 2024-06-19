{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, cargo
, desktop-file-utils
, appstream-glib
, meson
, ninja
, pkg-config
, reuse
, rustc
, m4
, wrapGAppsHook4
, glib
, gtk4
, gst_all_1
, libadwaita
, dbus
}:

stdenv.mkDerivation rec {
  pname = "amberol";
  version = "0.10.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-nAoUO0bGToNGD2W8qJmTegrETOJDdM04hI1jjiYkZXI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-4ZoliqQ665KPDFl+1eBCE+1fZgr+FA7vesPstoRs0RU=";
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
    reuse
    m4
    wrapGAppsHook4
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
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    dbus
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "A small and simple sound and music player";
    maintainers = with maintainers; [ linsui ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "amberol";
  };
}
