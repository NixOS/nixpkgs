{
  stdenv,
  lib,
  gettext,
  libxml2,
  libhandy,
  fetchurl,
  fetchpatch,
  pkg-config,
  libcanberra-gtk3,
  gtk3,
  glib,
  meson,
  ninja,
  python3,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
  gnome,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gnome-screenshot";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-screenshot/${lib.versions.major version}/gnome-screenshot-${version}.tar.xz";
    hash = "sha256-Stt97JJkKPdCY9V5ZnPPFC5HILbnaPVGio0JM/mMlZc=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.gnome.org/GNOME/gnome-screenshot/-/issues/186
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-screenshot/-/commit/b60dad3c2536c17bd201f74ad8e40eb74385ed9f.patch";
      hash = "sha256-Js83h/3xxcw2hsgjzGa5lAYFXVrt6MPhXOTh5dZTx/w=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    appstream-glib
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libcanberra-gtk3
    libhandy
    adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/postinstall.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-screenshot";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-screenshot";
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    mainProgram = "gnome-screenshot";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
