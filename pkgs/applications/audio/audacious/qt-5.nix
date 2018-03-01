{
  mkDerivation, lib, fetchurl, fetchpatch,
  gettext, pkgconfig,
  qtbase,
  alsaLib, curl, faad2, ffmpeg, flac, fluidsynth, gdk_pixbuf, lame, libbs2b,
  libcddb, libcdio, libcue, libjack2, libmad, libmms, libmodplug,
  libmowgli, libnotify, libogg, libpulseaudio, libsamplerate, libsidplayfp,
  libsndfile, libvorbis, libxml2, lirc, mpg123, neon, qtmultimedia, soxr,
  wavpack
}:

let
  version = "3.9";
  sources = {
    "audacious-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
      sha256 = "0pmhrhsjhqnrq3zh4rhfys5jas53ph5ijkq010dxg1n779kl901d";
    };

    "audacious-plugins-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
      sha256 = "1f17r7ar0mngcf7z41s6xh073vjafw3i7iy9ijb0cd6bi48g5xwb";
    };
  };

  qt510_plugins_patch = fetchpatch {
    url = "https://github.com/audacious-media-player/audacious-plugins/commit/971f7ff7c3d8a0b9b420bf4fd19ab97755607637.patch";
    sha256 = "15fy37syj9ygl2ibkkz3g3b9wd22vk9bjfmvqhhkpxphry2zwb17";
  };
in

mkDerivation {
  inherit version;
  name = "audacious-qt5-${version}";

  sourceFiles = lib.attrValues sources;
  sourceRoots = lib.attrNames sources;

  nativeBuildInputs = [ gettext pkgconfig ];

  inherit qt510_plugins_patch;

  buildInputs = [
    # Core dependencies
    qtbase

    # Plugin dependencies
    alsaLib curl faad2 ffmpeg flac fluidsynth gdk_pixbuf lame libbs2b libcddb
    libcdio libcue libjack2 libmad libmms libmodplug libmowgli
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
        # only patch the plugins
        if [ "$i" -eq "1" ]; then
          patches=( $qt510_plugins_patch )
        fi
        src=''${sourceFiles[$i]}
        sourceRoot=''${sourceRoots[$i]}
        source $stdenv/setup
        genericBuild
      )

      if [ $i == 0 ]; then
        nativeBuildInputs="$out $nativeBuildInputs"
      fi

    done
  '';

  meta = with lib; {
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
