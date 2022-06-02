{ config, lib, stdenv, fetchFromGitHub
, autoconf
, automake
, libtool
, intltool
, pkg-config
, jansson
# deadbeef can use either gtk2 or gtk3
, gtk2Support ? false, gtk2
, gtk3Support ? true, gtk3, gsettings-desktop-schemas, wrapGAppsHook
# input plugins
, vorbisSupport ? true, libvorbis
, mp123Support ? true, libmad
, flacSupport ? true, flac
, wavSupport ? true, libsndfile
, cdaSupport ? true, libcdio, libcddb
, aacSupport ? true, faad2
, opusSupport ? true, opusfile
, wavpackSupport ? false, wavpack
, ffmpegSupport ? false, ffmpeg
, apeSupport ? true, yasm
# misc plugins
, zipSupport ? true, libzip
, artworkSupport ? true, imlib2
, hotkeysSupport ? true, libX11
, osdSupport ? true, dbus
# output plugins
, alsaSupport ? true, alsa-lib
, pulseSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
# effect plugins
, resamplerSupport ? true, libsamplerate
, overloadSupport ? true, zlib
# transports
, remoteSupport ? true, curl
}:

assert gtk2Support || gtk3Support;

stdenv.mkDerivation rec {
  pname = "deadbeef";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = "deadbeef";
    rev = version;
    sha256 = "161b0ll8v4cjgwwmk137hzvh0jidlkx56vjkpnr70f0x4jzv2nll";
  };

  buildInputs = with lib; [ jansson ]
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
    ++ optional alsaSupport alsa-lib
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
    pkg-config
  ] ++ lib.optional gtk3Support wrapGAppsHook;

  enableParallelBuilding = true;

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Ultimate Music Player for GNU/Linux";
    homepage = "http://deadbeef.sourceforge.net/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.abbradar ];
  };
}
