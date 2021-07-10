{ config, lib, stdenv, fetchFromGitHub
,  glib
,  gobject-introspection
,  python3
,  pkg-config
,  ninja
,  wayland
,  wayland-protocols
,  desktop-file-utils
,  makeWrapper
,  shared-mime-info
,  wrapGAppsHook
,  meson, gjs, gtk4, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "clapper";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "Rafostar";
    repo   = pname;
    rev    = version;
    sha256 = "0gvn36njyhvz1hcywmdkla5as0qdqgc1bvkymmaipn26d80vxkdr";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    glib
    gobject-introspection
    meson
    ninja
    makeWrapper
    pkg-config
    python3
    shared-mime-info # for update-mime-database
    wrapGAppsHook # for gsettings
  ];

  buildInputs = [
    gjs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    gtk4
    wayland
    wayland-protocols
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  postInstall = ''
    mv $out/bin $out/nobin
    # Clapper reads argv[0] and expects its to be com.github.rafostar.Clapper.
    # Thus, we cannot use wrapProgram: doing so would make argv[0] == .com.github.rafostar.Clapper-wrapped.
    makeWrapper $out/nobin/com.github.rafostar.Clapper $out/bin/com.github.rafostar.Clapper --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"

    # Provide a CLI-friendly binary name.
    ln -s $out/bin/com.github.rafostar.Clapper $out/bin/clapper
  '';

  meta = with lib; {
    description = "A GNOME media player built using GJS with GTK4 toolkit and powered by GStreamer with OpenGL rendering. ";
    homepage = "https://github.com/Rafostar/clapper";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;

    longDescription = ''
      Clapper is a GNOME media player build using GJS with GTK4 toolkit.
      The media player is using GStreamer as a media backend and
      renders everything via OpenGL.
    '';
  };
}
