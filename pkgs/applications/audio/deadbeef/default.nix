{ stdenv, fetchurl, intltool, pkgconfig, fetchpatch, jansson
# deadbeef can use either gtk2 or gtk3
, gtk2Support ? false, gtk2 ? null
, gtk3Support ? true, gtk3 ? null, gsettings_desktop_schemas ? null, wrapGAppsHook ? null
# input plugins
, vorbisSupport ? true, libvorbis ? null
, mp123Support ? true, libmad ? null
, flacSupport ? true, flac ? null
, wavSupport ? true, libsndfile ? null
, cdaSupport ? true, libcdio ? null, libcddb ? null
, aacSupport ? true, faad2 ? null
, midiSupport ? false, wildmidi ? null
, wavpackSupport ? false, wavpack ? null
, ffmpegSupport ? false, ffmpeg ? null
, apeSupport ? true, yasm ? null
# misc plugins
, zipSupport ? true, libzip ? null
, artworkSupport ? true, imlib2 ? null
, hotkeysSupport ? true, libX11 ? null
, osdSupport ? true, dbus ? null
# output plugins
, alsaSupport ? true, alsaLib ? null
, pulseSupport ? true, libpulseaudio ? null
# effect plugins
, resamplerSupport ? true, libsamplerate ? null
, overloadSupport ? true, zlib ? null
# transports
, remoteSupport ? true, curl ? null
}:

assert gtk2Support || gtk3Support;
assert gtk2Support -> gtk2 != null;
assert gtk3Support -> gtk3 != null && gsettings_desktop_schemas != null && wrapGAppsHook != null;
assert vorbisSupport -> libvorbis != null;
assert mp123Support -> libmad != null;
assert flacSupport -> flac != null;
assert wavSupport -> libsndfile != null;
assert cdaSupport -> (libcdio != null && libcddb != null);
assert aacSupport -> faad2 != null;
assert zipSupport -> libzip != null;
assert ffmpegSupport -> ffmpeg != null;
assert apeSupport -> yasm != null;
assert artworkSupport -> imlib2 != null;
assert hotkeysSupport -> libX11 != null;
assert osdSupport -> dbus != null;
assert alsaSupport -> alsaLib != null;
assert pulseSupport -> libpulseaudio != null;
assert resamplerSupport -> libsamplerate != null;
assert overloadSupport -> zlib != null;
assert midiSupport -> wildmidi != null;
assert wavpackSupport -> wavpack != null;
assert remoteSupport -> curl != null;

stdenv.mkDerivation rec {
  name = "deadbeef-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/deadbeef/${name}.tar.bz2";
    sha256 = "0rwdxxn7h94vlgblbkswyvj6pm82488v8x5nrmlrcsbzjjf2pccw";
  };

  buildInputs = with stdenv.lib; [ jansson ]
    ++ optional gtk2Support gtk2
    ++ optionals gtk3Support [ gtk3 gsettings_desktop_schemas ]
    ++ optional vorbisSupport libvorbis
    ++ optional mp123Support libmad
    ++ optional flacSupport flac
    ++ optional wavSupport libsndfile
    ++ optionals cdaSupport [ libcdio libcddb ]
    ++ optional aacSupport faad2
    ++ optional zipSupport libzip
    ++ optional ffmpegSupport ffmpeg
    ++ optional apeSupport yasm
    ++ optional artworkSupport imlib2
    ++ optional hotkeysSupport libX11
    ++ optional osdSupport dbus
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optional resamplerSupport libsamplerate
    ++ optional overloadSupport zlib
    ++ optional midiSupport wildmidi
    ++ optional wavpackSupport wavpack
    ++ optional remoteSupport curl
    ;

  nativeBuildInputs = with stdenv.lib; [ intltool pkgconfig ]
    ++ optional gtk3Support wrapGAppsHook;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Ultimate Music Player for GNU/Linux";
    homepage = http://deadbeef.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
    repositories.git = "https://github.com/Alexey-Yakovenko/deadbeef";
  };
}
