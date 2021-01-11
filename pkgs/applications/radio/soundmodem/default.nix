{ lib, stdenv, fetchurl, pkg-config, alsaLib, audiofile, gtk2, libxml2 }:

stdenv.mkDerivation rec {
  name = "soundmodem";
  version = "0.20";

  src = fetchurl {
    url = "https://archive.org/download/${name}-${version}/${name}-${version}.tar.gz";
    sha256 = "156l3wjnh5rcisxb42kcmlf74swf679v4xnj09zy5j74rd4h721z";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib audiofile gtk2 libxml2 ];

  patches = [ ./matFix.patch ];

  doCheck = true;

  meta = with lib; {
    description = "Audio based modem for ham radio supporting ax.25";
    longDescription = ''
      This software allows a standard PC soundcard to be used as a packet radio "modem". The whole processing is done on the main processor CPU.
      Unlike previous packet radio modem software, this new release offers several new benefits:
        - Now uses standard operating system sound drivers (OSS/Free under Linux, /dev/audio under Solaris and DirectSound under Windows), thus runs on all soundcards for which drivers for the desired operating system are available.
        - No fixed relationship between bitrate, sampling rate, and modem parameters. Modems may be parametrized, and multiple modems may even run on the same audio channel!
        - Usermode solution allows the use of MMX, VIS, Floating point and other media instruction sets to speed up computation.
        - Cross platform builds from a single source code provides ubiquitous availability.
    '';
    #homepage = "http://gna.org/projects/soundmodem"; # official, but "Connection refused"
    homepage = "http://soundmodem.vk4msl.id.au/";
    downloadPage = "https://archive.org/download/${name}-${version}/${name}-${version}.tar.gz";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ymarkus ];
    platforms = platforms.all;
  };
}
