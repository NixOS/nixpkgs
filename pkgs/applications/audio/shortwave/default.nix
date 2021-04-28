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
, gtk3
, libhandy_0
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
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "1vlhp2ss06j41simjrrjg38alp85jddhqyvccy6bhfzm0gzynwld";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-0+KEbjTLecL0u/3S9FWf2r2h9ZrgcRTY163kS3NKJqA=";
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
    gtk3
    libhandy_0
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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
