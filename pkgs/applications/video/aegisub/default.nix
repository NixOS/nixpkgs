{ stdenv, fetchurl
, libX11, gettext, wxGTK
, libiconv, fontconfig, freetype
, mesa
, libass, fftw, ffms
, ffmpeg, pkgconfig, zlib # Undocumented (?) dependencies
, spellChecking ? true, hunspell ? null
, automationSupport ? true, lua ? null
, openalSupport ? false, openal ? null
, alsaSupport ? true, alsaLib ? null
, pulseaudioSupport ? true, pulseaudio ? null
, portaudioSupport ? false, portaudio ? null
}:

assert spellChecking -> (hunspell != null);
assert automationSupport -> (lua != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsaLib != null);
assert pulseaudioSupport -> (pulseaudio != null);
assert portaudioSupport -> (portaudio != null);

stdenv.mkDerivation rec {
  name = "aegisub-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "http://ftp.aegisub.org/pub/releases/${name}.tar.xz";
    md5 = "0f22d63ed4c502f3801795fa623a4f41";
  };

  buildInputs = with stdenv.lib;
  [ libX11 gettext wxGTK libiconv fontconfig freetype mesa libass fftw ffms ffmpeg pkgconfig zlib ]
  ++ optional spellChecking hunspell
  ++ optional automationSupport lua
  ++ optional openalSupport openal
  ++ optional alsaSupport alsaLib
  ++ optional pulseaudioSupport pulseaudio
  ++ optional portaudioSupport portaudio
  ;

  NIX_LDFLAGS = "-liconv -lavutil -lavformat -lavcodec -lswscale -lz -lm";

  preConfigure = "cd aegisub";

  postInstall = "ln -s $out/bin/aegisub-3.0 $out/bin/aegisub";

  meta = {
    description = "An advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    homepage = http://www.aegisub.org/;
    license = stdenv.lib.licenses.bsd3;
              # The Aegisub sources are itself BSD/ISC,
              # but they are linked against GPL'd softwares
              # - so the resulting program will be GPL
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;

  };
}
