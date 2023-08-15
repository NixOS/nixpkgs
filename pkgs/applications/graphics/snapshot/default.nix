{ stdenv
, lib
, fetchurl
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
  version = "45.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major version}/snapshot-${version}.tar.xz";
    hash = "sha256-Dxi06QoLHxL5pqFh3zGBZ/n8zoxW7iWW+QNs21qfRvg=";
  };

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
