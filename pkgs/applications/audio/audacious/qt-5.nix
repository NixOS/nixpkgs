{
  stdenv, lib, fetchurl,
  gettext, makeQtWrapper, pkgconfig,
  qtbase,
  alsaLib, curl, faad2, ffmpeg, flac, fluidsynth, gdk_pixbuf, lame, libbs2b,
  libcddb, libcdio082, libcue, libjack2, libmad, libmcs, libmms, libmodplug,
  libmowgli, libnotify, libogg, libpulseaudio, libsamplerate, libsidplayfp,
  libsndfile, libvorbis, libxml2, lirc, mpg123, neon, qtmultimedia, soxr,
  wavpack
}:

let
  version = "3.8.1";
  sources = {
    "audacious-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
      sha256 = "1k9blmgqia0df18l39bd2bbcwmjfxak6bd286vcd9zzmjhqs4qdc";
    };

    "audacious-plugins-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
      sha256 = "0f16ivcp8nd83r781hnw1qgbs9hi2b2v22zwv7c3sw3jq1chb70h";
    };
  };
in

stdenv.mkDerivation {
  inherit version;
  name = "audacious-${version}";

  sourceFiles = lib.attrValues sources;
  sourceRoots = lib.attrNames sources;

  nativeBuildInputs = [
    gettext makeQtWrapper pkgconfig
  ];

  buildInputs = [
    # Core dependencies
    qtbase

    # Plugin dependencies
    alsaLib curl faad2 ffmpeg flac fluidsynth gdk_pixbuf lame libbs2b libcddb
    libcdio082 libcue libjack2 libmad libmcs libmms libmodplug libmowgli
    libnotify libogg libpulseaudio libsamplerate libsidplayfp libsndfile
    libvorbis libxml2 lirc mpg123 neon qtmultimedia soxr wavpack
  ];

  configureFlags = [ "--enable-qt" "--disable-gtk" ];

  # Here we build both audacious and audacious-plugins in one
  # derivations, since they really expect to be in the same prefix.
  # This is slighly tricky.
  builder = builtins.toFile "builder.sh" ''
    sourceFiles=( $sourceFiles )
    sourceRoots=( $sourceRoots )
    for (( i=0 ; i < ''${#sourceFiles[*]} ; i++ )); do

      (
        src=''${sourceFiles[$i]}
        sourceRoot=''${sourceRoots[$i]}
        source $stdenv/setup
        genericBuild
      )

      if [ $i == 0 ]; then
        nativeBuildInputs="$out $nativeBuildInputs"
      fi

    done

    source $stdenv/setup
    wrapQtProgram $out/bin/audacious
    wrapQtProgram $out/bin/audtool
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Audio player";
    homepage = http://audacious-media-player.org/;
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; linux;
    license = with licenses; [
      bsd2 bsd3 #https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2 gpl3 lgpl2Plus #http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
