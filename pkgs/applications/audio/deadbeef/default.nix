{ config, stdenv, fetchFromGitHub
, autoconf
, automake
, libtool
, intltool
, pkgconfig
, jansson
# deadbeef can use either gtk2 or gtk3
, gtk2Support ? false, gtk2 ? null
, gtk3Support ? true, gtk3 ? null, gsettings-desktop-schemas ? null, wrapGAppsHook ? null
# input plugins
, vorbisSupport ? true, libvorbis ? null
, mp123Support ? true, libmad ? null
, flacSupport ? true, flac ? null
, wavSupport ? true, libsndfile ? null
, cdaSupport ? true, libcdio ? null, libcddb ? null
, aacSupport ? true, faad2 ? null
, opusSupport ? true, opusfile ? null
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
, pulseSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
# effect plugins
, resamplerSupport ? true, libsamplerate ? null
, overloadSupport ? true, zlib ? null
# transports
, remoteSupport ? true, curl ? null
}:

assert gtk2Support || gtk3Support;
assert gtk2Support -> gtk2 != null;
assert gtk3Support -> gtk3 != null && gsettings-desktop-schemas != null && wrapGAppsHook != null;
assert vorbisSupport -> libvorbis != null;
assert mp123Support -> libmad != null;
assert flacSupport -> flac != null;
assert wavSupport -> libsndfile != null;
assert cdaSupport -> (libcdio != null && libcddb != null);
assert aacSupport -> faad2 != null;
assert opusSupport -> opusfile != null;
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
assert wavpackSupport -> wavpack != null;
assert remoteSupport -> curl != null;

stdenv.mkDerivation rec {
  pname = "deadbeef";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = "deadbeef";
    rev = version;
    sha256 = "126i5qlkpv7pvi1mmc9y0jhqs6jjspsj7j615n2ddvsb2jsps81c";
  };

  patches = [
    # Fix broken symbol name
    # https://github.com/NixOS/nixpkgs/pull/59187#issuecomment-480977993
    # will be fixed in deadbeef 1.8.1
    ./fix-wildmidi.patch
  ];

  buildInputs = with stdenv.lib; [ jansson ]
    ++ optional gtk2Support gtk2
    ++ optionals gtk3Support [ gtk3 gsettings-desktop-schemas ]
    ++ optional vorbisSupport libvorbis
    ++ optional mp123Support libmad
    ++ optional flacSupport flac
    ++ optional wavSupport libsndfile
    ++ optionals cdaSupport [ libcdio libcddb ]
    ++ optional aacSupport faad2
    ++ optional opusSupport opusfile
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
    ++ optional wavpackSupport wavpack
    ++ optional remoteSupport curl
    ;

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    pkgconfig
  ] ++ stdenv.lib.optional gtk3Support wrapGAppsHook;

  enableParallelBuilding = true;

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Ultimate Music Player for GNU/Linux";
    homepage = http://deadbeef.sourceforge.net/;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.abbradar ];
    repositories.git = "https://github.com/Alexey-Yakovenko/deadbeef";
  };
}
