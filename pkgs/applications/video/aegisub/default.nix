{ stdenv, fetchurl
, libX11, wxGTK
, libiconvOrEmpty, fontconfig, freetype
, mesa
, libass, fftw, ffms
, ffmpeg, pkgconfig, zlib # Undocumented (?) dependencies
, icu, boost, intltool # New dependencies
, spellChecking ? true, hunspell ? null
, automationSupport ? true, lua ? null
, openalSupport ? false, openal ? null
, alsaSupport ? true, alsaLib ? null
, pulseaudioSupport ? true, pulseaudio ? null
, portaudioSupport ? false, portaudio ? null }:

assert spellChecking -> (hunspell != null);
assert automationSupport -> (lua != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsaLib != null);
assert pulseaudioSupport -> (pulseaudio != null);
assert portaudioSupport -> (portaudio != null);

stdenv.mkDerivation rec {
  name = "aegisub-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "http://ftp.aegisub.org/pub/releases/${name}.tar.xz";
    sha256 = "1p7qdnxyyyrlpvxdrrp15b5967d7bzpjl3vdy0q66g4aabr2h6ln";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig intltool libX11 wxGTK fontconfig freetype mesa
    libass fftw ffms ffmpeg zlib icu boost boost.lib
  ]
    ++ libiconvOrEmpty
    ++ optional spellChecking hunspell
    ++ optional automationSupport lua
    ++ optional openalSupport openal
    ++ optional alsaSupport alsaLib
    ++ optional pulseaudioSupport pulseaudio
    ++ optional portaudioSupport portaudio
    ;


  enableParallelBuilding = true;

  postInstall = "ln -s $out/bin/aegisub-* $out/bin/aegisub";

  meta = with stdenv.lib; {
    description = "An advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    homepage = http://www.aegisub.org/;
    license = licenses.bsd3;
              # The Aegisub sources are itself BSD/ISC,
              # but they are linked against GPL'd softwares
              # - so the resulting program will be GPL
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
