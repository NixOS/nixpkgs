{stdenv, fetchurl
, libX11, gettext, wxGTK29
, libiconv, fontconfig, freetype
, mesa
, libass, fftw, ffms
, ffmpeg, pkgconfig, zlib # Undocumented (?) dependencies
, spellChecking ? true, hunspell ? null
, automationSupport ? true, lua5_1 ? null 
, openalSupport ? false, openal ? null
, alsaSupport ? true, alsaLib ? null
}:

assert spellChecking -> (hunspell != null);
assert automationSupport -> (lua5_1 != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsaLib != null);


stdenv.mkDerivation rec {
  
  name = "aegisub-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "http://ftp.aegisub.org/pub/releases/${name}.tar.xz";
    md5 = "0f22d63ed4c502f3801795fa623a4f41";
  };

  buildInputs = with stdenv.lib;
  [ libX11 gettext wxGTK29 libiconv fontconfig freetype mesa libass fftw ffms ffmpeg pkgconfig zlib ]
  ++ optional spellChecking hunspell
  ++ optional automationSupport lua5_1
  ++ optional openalSupport openal
  ++ optional alsaSupport alsaLib
  ;

  NIX_LDFLAGS = "-liconv -lavutil -lavformat -lavcodec -lswscale -lz -lm";
  
  preConfigure = "cd aegisub"; 
  
  meta = {
    description = "An advanced subtitle editor";
    longDescription = ''
    Aegisub is a free, cross-platform open source tool for creating and modifying subtitles. Aegisub makes it quick and easy to time subtitles to audio, and features many powerful tools for styling them, including a built-in real-time video preview.
    '';
    homepage = http://www.aegisub.org/;
    license = "BSD"; # The sources are BSD/ISC, but they are linked against GPL'd softwares
    platforms = stdenv.lib.platforms.linux;
  };
}

# TODO: parametrize lua version
# TODO: parametrize wxGTK version

