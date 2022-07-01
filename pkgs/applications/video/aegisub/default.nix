{ lib
, config
, stdenv
, fetchFromGitHub
, autoreconfHook
, boost
, ffmpeg
, ffms
, fftw
, fontconfig
, freetype
, icu
, intltool
, libGL
, libGLU
, libX11
, libass
, libiconv
, libuchardet
, pkg-config
, which
, wxGTK
, zlib

, spellcheckSupport ? true
, hunspell ? null

, automationSupport ? true
, luajit ? null

, openalSupport ? false
, openal ? null

, alsaSupport ? stdenv.isLinux
, alsa-lib ? null

, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null

, portaudioSupport ? false
, portaudio ? null

}:

assert spellcheckSupport -> (hunspell != null);
assert automationSupport -> (luajit != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsa-lib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null);

let
  luajit52 = luajit.override { enable52Compat = true; };
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "aegisub";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "wangqr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Er0g8fJyx7zjNVpKw7zUHE40hU10BdYlZohlqJq2LE0=";
  };

  patches = [ ./no-git.patch ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    luajit52
    pkg-config
    which
  ];
  buildInputs = [
    boost
    ffmpeg
    ffms
    fftw
    fontconfig
    freetype
    icu
    libGL
    libGLU
    libX11
    libass
    libiconv
    libuchardet
    wxGTK
    zlib
  ]
  ++ optional alsaSupport alsa-lib
  ++ optional automationSupport luajit52
  ++ optional openalSupport openal
  ++ optional portaudioSupport portaudio
  ++ optional pulseaudioSupport libpulseaudio
  ++ optional spellcheckSupport hunspell
  ;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-system-luajit"
    "FORCE_GIT_VERSION=${version}"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  postInstall = "ln -s $out/bin/aegisub-* $out/bin/aegisub";

  meta = with lib; {
    homepage = "https://github.com/wangqr/Aegisub";
    description = "An advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # softwares - so the resulting program will be GPL
    license = licenses.bsd3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
