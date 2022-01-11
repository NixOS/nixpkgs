{ stdenv
, lib
, fetchFromGitLab
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
, python3
, rustPlatform
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "shortwave";
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "sha256-25qPb7qlqCwYJzl4qZxAZYx5asxSlXBlc/0dGyBdk1o=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-00dQXcSNmdZb2nSLG3q7jm4sugF9XR4LbH0OmcuHVxA=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gitMinimal
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    sqlite
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Shortwave";
    description = "Find and listen to internet radio stations";
    longDescription = ''
      Shortwave is a streaming audio player designed for the GNOME
      desktop. It is the successor to the older Gradio application.
    '';
    maintainers = with maintainers; [ lasandell ];
    broken = true; # incompatible with latest libadwaita
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
