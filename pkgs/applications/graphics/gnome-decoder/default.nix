{ lib
, clangStdenv
, fetchFromGitLab
, rustPlatform
, cargo
, meson
, ninja
, pkg-config
, rustc
, glib
, gtk4
, libadwaita
, zbar
, sqlite
, openssl
, pipewire
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

clangStdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    hash = "sha256-ZEt4QaT2w7PgsnwBCYeDbhcYX0yd0boes/LoejQx0XU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-acYOSPSUgm0Kg/bo2WF4sRWfCt03AZdTyNNt3Qv7Zjg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    zbar
    sqlite
    openssl
    pipewire
    gstreamer
    gst-plugins-base
    gst-plugins-bad
  ];

  meta = with lib; {
    description = "Scan and Generate QR Codes";
    homepage = "https://gitlab.gnome.org/World/decoder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "decoder";
    maintainers = with maintainers; [ zendo ];
  };
}
