{ stdenv, fetchurl, pkgconfig, wrapGAppsHook, gettext, glib, gtk3
, libmowgli, libmcs, dbus_glib, libxml2, xorg, gnome3, alsaLib
, libpulseaudio, libjack2, fluidsynth, libmad, libogg, libvorbis
, libcdio082, libcddb, flac, ffmpeg, mpg123, libcue, libmms, libbs2b
, libsndfile, libmodplug, libsamplerate, soxr, lirc, curl, wavpack
, neon, faad2, lame, libnotify, libsidplayfp
}:

stdenv.mkDerivation rec {
  name = "audacious-${version}";
  version = "3.8";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}-gtk3.tar.bz2";
    sha256 = "0rpdzf9pb52lcswxypwh4nq3qkjzliw42v39nm5rlwwxdq6bm99q";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}-gtk3.tar.bz2";
    sha256 = "0j9svdqdjvj5spx1vfp0m63xh8xwk8naqsikdxfxbb68xk33rxb9";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook
  ];

  buildInputs = [
    gettext glib gtk3 libmowgli libmcs dbus_glib libxml2
    xorg.libXcomposite gnome3.defaultIconTheme alsaLib libjack2
    libpulseaudio fluidsynth libmad libogg libvorbis libcdio082
    libcddb flac ffmpeg mpg123 libcue libmms libbs2b libsndfile
    libmodplug libsamplerate soxr lirc curl wavpack neon faad2
    lame libnotify libsidplayfp
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
      dontWrapGApps=true
      nativeBuildInputs="$out $nativeBuildInputs" # to find audacious
      source $stdenv/setup
      rm -rfv audacious-*
      src=$pluginsSrc
      genericBuild
    )
  '';

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
