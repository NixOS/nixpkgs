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
, gst-plugins-good
, gst-plugins-rs
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glycin-loaders
}:

clangStdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    hash = "sha256-qSPuEVW+FwC9OJa+dseIy4/2bhVdTryJSJNSpes9tpY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-MbfukvqlzZPnWNtWCwYn7lABqBxtZWvPDba9Deah+w8=";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst-plugins-good}/share/gstreamer-1.0/presets"
      # See https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

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
    gst-plugins-good
    gst-plugins-rs # for gtk4paintablesink
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
