{ stdenv
, lib
, fetchFromGitLab
, cargo
, dbus
, desktop-file-utils
, gdk-pixbuf
, gettext
, gitMinimal
, glib
, gst_all_1
, gtk4
, libadwaita
, meson
, ninja
, openssl
, pkg-config
, rustPlatform
, rustc
, sqlite
, wrapGAppsHook4
, cmake
, libshumate
}:

stdenv.mkDerivation rec {
  pname = "shortwave";
  version = "3.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "sha256-ESZ1yD1IuBar8bv83xMczZbtPtHbWRpe2yMVyr7K5gQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8W46bGAitR2YbZbnsigAZMW5pSFTkDAe5JNaNOH5JfA=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gitMinimal
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    cmake
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    sqlite
    libshumate
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Shortwave";
    description = "Find and listen to internet radio stations";
    mainProgram = "shortwave";
    longDescription = ''
      Shortwave is a streaming audio player designed for the GNOME
      desktop. It is the successor to the older Gradio application.
    '';
    maintainers = with maintainers; [ lasandell ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
