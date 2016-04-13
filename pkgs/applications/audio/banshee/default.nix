{ pkgs, stdenv, lib, fetchurl, intltool, pkgconfig, gstreamer, gst_plugins_base
, gst_plugins_good, gst_plugins_bad, gst_plugins_ugly, gst_ffmpeg, glib
, mono, mono-addins, dbus-sharp-1_0, dbus-sharp-glib-1_0, notify-sharp, gtk-sharp-2_0
, boo, gdata-sharp, taglib-sharp, sqlite, gnome-sharp, gconf, gtk-sharp-beans, gio-sharp
, libmtp, libgpod, mono-zeroconf }:

stdenv.mkDerivation rec {
  name = "banshee-${version}";
  version = "2.6.2";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/banshee/2.6/banshee-${version}.tar.xz";
    sha256 = "1y30p8wxx5li39i5gpq2wib0ympy8llz0gyi6ri9bp730ndhhz7p";
  };

  dontStrip = true;

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [
    gtk-sharp-2_0.gtk gstreamer gst_plugins_base gst_plugins_good
    gst_plugins_bad gst_plugins_ugly gst_ffmpeg
    mono dbus-sharp-1_0 dbus-sharp-glib-1_0 mono-addins notify-sharp
    gtk-sharp-2_0 boo gdata-sharp taglib-sharp sqlite gnome-sharp gconf gtk-sharp-beans
    gio-sharp libmtp libgpod mono-zeroconf
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    patchShebangs data/desktop-files/update-desktop-file.sh
    patchShebangs build/private-icon-theme-installer
    sed -i "s,DOCDIR=.*,DOCDIR=$out/lib/monodoc," configure
  '';

  postInstall = let
    ldLibraryPath = lib.makeLibraryPath [ gtk-sharp-2_0.gtk gtk-sharp-2_0 sqlite gconf glib gstreamer ];

    monoGACPrefix = lib.concatStringsSep ":" [
      mono dbus-sharp-1_0 dbus-sharp-glib-1_0 mono-addins notify-sharp gtk-sharp-2_0
      boo gdata-sharp taglib-sharp sqlite gnome-sharp gconf gtk-sharp-beans
      gio-sharp libmtp libgpod mono-zeroconf
    ];
  in ''
    sed -e '2a export MONO_GAC_PREFIX=${monoGACPrefix}' \
        -e 's|LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${ldLibraryPath}:|' \
        -e "s|GST_PLUGIN_PATH=|GST_PLUGIN_PATH=$GST_PLUGIN_SYSTEM_PATH:|" \
        -e 's| mono | ${mono}/bin/mono |' \
        -i $out/bin/banshee
  '';
  meta = with lib; {
    description = "A music player written in C# using GNOME technologies";
    platforms = platforms.linux;
    maintainers = [ maintainers.zohl ];
  };
}
