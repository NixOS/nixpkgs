{ stdenv, fetchurl, intltool, pkgconfig
# deadbeef can use either gtk2 or gtk3
, gtk2Support ? true, gtk2 ? null
, gtk3Support ? false, gtk3 ? null, gsettings_desktop_schemas ? null, makeWrapper ? null
# input plugins
, vorbisSupport ? true, libvorbis ? null
, mp123Support ? true, libmad ? null
, flacSupport ? true, flac ? null
, wavSupport ? true, libsndfile ? null
, cdaSupport ? true, libcdio ? null, libcddb ? null
, aacSupport ? true, faad2 ? null
, wavpackSupport ? false, wavpack ? null
, ffmpegSupport ? false, ffmpeg ? null
# misc plugins
, zipSupport ? true, libzip ? null
, artworkSupport ? true, imlib2 ? null
, hotkeysSupport ? true, libX11 ? null
, osdSupport ? true, dbus ? null
# output plugins
, alsaSupport ? true, alsaLib ? null
, pulseSupport ? true, pulseaudio ? null
# effect plugins
, resamplerSupport ? true, libsamplerate ? null
, overloadSupport ? true, zlib ? null
# transports
, remoteSupport ? true, curl ? null
}:

assert gtk2Support || gtk3Support;
assert gtk2Support -> gtk2 != null;
assert gtk3Support -> gtk3 != null && gsettings_desktop_schemas != null && makeWrapper != null;
assert vorbisSupport -> libvorbis != null;
assert mp123Support -> libmad != null;
assert flacSupport -> flac != null;
assert wavSupport -> libsndfile != null;
assert cdaSupport -> (libcdio != null && libcddb != null);
assert aacSupport -> faad2 != null;
assert zipSupport -> libzip != null;
assert ffmpegSupport -> ffmpeg != null;
assert artworkSupport -> imlib2 != null;
assert hotkeysSupport -> libX11 != null;
assert osdSupport -> dbus != null;
assert alsaSupport -> alsaLib != null;
assert pulseSupport -> pulseaudio != null;
assert resamplerSupport -> libsamplerate != null;
assert overloadSupport -> zlib != null;
assert wavpackSupport -> wavpack != null;
assert remoteSupport -> curl != null;

stdenv.mkDerivation rec {
  name = "deadbeef-0.6.2";

  src = fetchurl {
    url = "http://garr.dl.sourceforge.net/project/deadbeef/${name}.tar.bz2";
    sha256 = "06jfsqyakpvq0xhah7dlyvdzh5ym3hhb4yfczczw11ijd1kbjcrl";
  };

  buildInputs = with stdenv.lib;
       optional gtk2Support gtk2
    ++ optionals gtk3Support [gtk3 gsettings_desktop_schemas]
    ++ optional vorbisSupport libvorbis
    ++ optional mp123Support libmad
    ++ optional flacSupport flac
    ++ optional wavSupport libsndfile
    ++ optionals cdaSupport [libcdio libcddb]
    ++ optional aacSupport faad2
    ++ optional zipSupport libzip
    ++ optional ffmpegSupport ffmpeg
    ++ optional artworkSupport imlib2
    ++ optional hotkeysSupport libX11
    ++ optional osdSupport dbus
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport pulseaudio
    ++ optional resamplerSupport libsamplerate
    ++ optional overloadSupport zlib
    ++ optional wavpackSupport wavpack
    ++ optional remoteSupport curl
    ;

  nativeBuildInputs = with stdenv.lib; [ intltool pkgconfig ]
    ++ optional gtk3Support makeWrapper;

  enableParallelBuilding = true;

  postInstall = if !gtk3Support then "" else ''
    wrapProgram "$out/bin/deadbeef" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Ultimate Music Player for GNU/Linux";
    homepage = http://deadbeef.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
    repositories.git = https://github.com/Alexey-Yakovenko/deadbeef;
  };
}
