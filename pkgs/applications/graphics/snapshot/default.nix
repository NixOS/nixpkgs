{ stdenv
, lib
, fetchurl
, fetchpatch
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4
, glib
, gst_all_1
, gtk4
, libadwaita
, pipewire
, gnome
}:

stdenv.mkDerivation rec {
  pname = "snapshot";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major version}/snapshot-${version}.tar.xz";
    hash = "sha256-7keO4JBzGgsIJLZrsXRr2ADcv+h6yDWEmUSa85z822c=";
  };

  patches = [
    # Fix portal requests
    # https://gitlab.gnome.org/GNOME/snapshot/-/merge_requests/168
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/snapshot/-/commit/6aec0f56d6bb994731c1309ac6e2cb822b82067e.patch";
      hash = "sha256-6tnOhhTQ3Rfl3nCw/rliLKkvZknvZKCQyeMKaTxYmok=";
    })
  ];

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk4
    libadwaita
    pipewire # for device provider
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "snapshot";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "snapshot";
  };
}
