{ stdenv, fetchurl, pkgconfig, autoconf, makeWrapper, gettext
, glib, gtk3, libmowgli, libmcs, dbus_glib, libxml2, xorg, gnome3
, alsaLib, libpulseaudio, libjack2, fluidsynth
, libmad, libogg, libvorbis, libcdio082, libcddb, flac, ffmpeg, mpg123
, libcue, libmms, libbs2b, libsndfile, libmodplug, libsamplerate
, soxr, lirc, curl, wavpack, neon, faad2, lame, libnotify, libsidplayfp
}:

stdenv.mkDerivation rec {
  name = "audacious-${version}";
  version = "3.7.2";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}-gtk3.tar.bz2";
    sha256 = "1pvyxi8niy70nv13kc16g2vaywwahmg2650fa7v4rlbmykifk75z";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}-gtk3.tar.bz2";
    sha256 = "0gxka0lp9a35k2xgq8bx69wyv83dvrqnpwcsqliy3h3yz6v1fv2v";
  };

  buildInputs = [
    pkgconfig autoconf makeWrapper gettext glib gtk3 libmowgli
    libmcs dbus_glib libxml2 xorg.libXcomposite gnome3.defaultIconTheme
    alsaLib libjack2 libpulseaudio fluidsynth
    libmad libogg libvorbis libcdio082 libcddb flac ffmpeg mpg123
    libcue libmms libbs2b libsndfile libmodplug libsamplerate
    soxr lirc curl wavpack neon faad2 lame libnotify libsidplayfp.out
  ];

  configureFlags = [ "--enable-statusicon" ];

  # Here we build both audacious and audacious-plugins in one
  # derivations, since they really expect to be in the same prefix.
  # This is slighly tricky.
  builder = builtins.toFile "builder.sh" ''
    # First build audacious.
    (
      source $stdenv/setup
      genericBuild
    )

    # Then build the plugins.
    (
      nativeBuildInputs="$out $nativeBuildInputs" # to find audacious
      source $stdenv/setup
      rm -rfv audacious-*
      src=$pluginsSrc
      genericBuild
    )

    (
      source $stdenv/setup
      # gsettings schemas for file dialogues
      # XDG_ICON_DIRS is set by hook for gnome3.defaultIconTheme
      for file in "$out/bin/"*; do
        wrapProgram "$file" \
          --prefix XDG_DATA_DIRS : "$XDG_ADD:$GSETTINGS_SCHEMAS_PATH" \
          --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
      done
    )
  '';

  XDG_ADD = gtk3 + "/share";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Audio player";
    homepage = http://audacious-media-player.org/;
    maintainers = with maintainers; [ eelco ramkromberg ];
    platforms = with platforms; linux;
    license = with licenses; [
      bsd2 bsd3 #https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2 gpl3 lgpl2Plus #http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
