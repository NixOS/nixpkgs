{ stdenv, fetchurl, lib
, pkgconfig, intltool, autoconf, gnome3
, glib, dbus, gtk3, libdbusmenu-gtk3, libappindicator-gtk3, gst_all_1
, librsvg, wrapGAppsHook
, pulseaudioSupport ? true, libpulseaudio ? null }:

with lib;

stdenv.mkDerivation rec {
  name = "audio-recorder-${version}";
  version = "1.9.4";

  src = fetchurl {
    name = "${name}-zesty.tar.gz";
    url = "${meta.homepage}/+archive/ubuntu/ppa/+files/audio-recorder_${version}%7Ezesty.tar.gz";
    sha256 = "062bad38cz4fqzv418wza0x8sa4m5mqr3xsisrr1qgkqj9hg1f6x";
  };

  nativeBuildInputs = [ pkgconfig intltool autoconf wrapGAppsHook ];

  patches = [ ./icon-names.diff ];

  buildInputs = with gst_all_1; [
    glib dbus gtk3 librsvg libdbusmenu-gtk3 libappindicator-gtk3 (stdenv.lib.getLib gnome3.dconf)
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
  ] ++ optional pulseaudioSupport libpulseaudio;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'PKG_CHECK_MODULES(GIO, gio-2.0 >= $GLIB_REQUIRED)' \
                'PKG_CHECK_MODULES(GIO, gio-2.0 >= $GLIB_REQUIRED gio-unix-2.0)'
    autoconf
    intltoolize
  '';

  preFixup = ''
    gappsWrapperArgs+=('--prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"'
      '--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"'
      '--prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules"')
  '';

  meta = with stdenv.lib; {
    description = "Audio recorder for GNOME and Unity Desktops";
    longDescription = ''
      This program allows you to record your favourite music or audio to a file.
      It can record audio from your system soundcard, microphones, browsers and
      webcams. Put simply; if it plays out of your loudspeakers you can record it.
      This program has a timer that can start, stop or pause recording on certain
      conditions such as audio level, file size and clock time. This recorder can
      automatically record your Skype calls. It supports several audio (output)
      formats such as OGG audio, Flac, MP3 and WAV.
    '';
    homepage = https://launchpad.net/~audio-recorder;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
