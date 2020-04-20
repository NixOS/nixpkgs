{ config
, stdenv
, fetchurl
, fetchpatch
, libX11
, wxGTK
, libiconv
, fontconfig
, freetype
, libGLU
, libGL
, libass
, fftw
, ffms
, ffmpeg
, pkg-config
, zlib
, icu
, boost
, intltool

, spellcheckSupport ? true
, hunspell ? null

, automationSupport ? true
, lua ? null

, openalSupport ? false
, openal ? null

, alsaSupport ? stdenv.isLinux
, alsaLib ? null

, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null

, portaudioSupport ? false
, portaudio ? null
}:

assert spellcheckSupport -> (hunspell != null);
assert automationSupport -> (lua != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsaLib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null);

with stdenv.lib;
stdenv.mkDerivation
 rec {
  pname = "aegisub";
  version = "3.2.2";

  src = fetchurl {
    url = "http://ftp.aegisub.org/pub/releases/${pname}-${version}.tar.xz";
    sha256 = "11b83qazc8h0iidyj1rprnnjdivj1lpphvpa08y53n42bfa36pn5";
  };

  patches = [
    # Compatibility with ICU 59
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/dd67db47cb2203e7a14058e52549721f6ff16a49.patch";
      sha256 = "07qqlckiyy64lz8zk1as0vflk9kqnjb340420lp9f0xj93ncssj7";
    })

    # Compatbility with Boost 1.69
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/c3c446a8d6abc5127c9432387f50c5ad50012561.patch";
      sha256 = "1n8wmjka480j43b1pr30i665z8hdy6n3wdiz1ls81wyv7ai5yygf";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = with stdenv.lib; [
    libX11
    wxGTK
    fontconfig
    freetype
    libGLU
    libGL
    libass
    fftw
    ffms
    ffmpeg
    zlib
    icu
    boost
    libiconv
  ]
    ++ optional spellcheckSupport hunspell
    ++ optional automationSupport lua
    ++ optional openalSupport openal
    ++ optional alsaSupport alsaLib
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional portaudioSupport portaudio
    ;

  enableParallelBuilding = true;

  hardeningDisable = [ "bindnow" "relro" ];

  # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
  CXXFLAGS = [ "-DU_USING_ICU_NAMESPACE=1" ];

  # this is fixed upstream though not yet in an officially released version,
  # should be fine remove on next release (if one ever happens)
  NIX_LDFLAGS = "-lpthread";

  postInstall = "ln -s $out/bin/aegisub-* $out/bin/aegisub";

  meta = {
    description = "An advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    homepage = "http://www.aegisub.org/";
    # The Aegisub sources are itself BSD/ISC,
    # but they are linked against GPL'd softwares
    # - so the resulting program will be GPL
    license = licenses.bsd3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
