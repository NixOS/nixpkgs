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
<<<<<<< HEAD
  version = "0.10.3";
=======
  version = "0.10.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-nAoUO0bGToNGD2W8qJmTegrETOJDdM04hI1jjiYkZXI=";
=======
    hash = "sha256-edYLdsXlk+3YGyG6bxR8E8q1bzaXWk04v/NxfaxcNhI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-4ZoliqQ665KPDFl+1eBCE+1fZgr+FA7vesPstoRs0RU=";
=======
    hash = "sha256-bhB1hFFLYf+TH3pDCyx/hJqPxBdoPjtPBluK9yygpTk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };
}
