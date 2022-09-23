{ lib
, config
, stdenv
, fetchFromGitHub
, boost
, cmake
, expat
, harfbuzz
, ffmpeg
, ffms
, fftw
, fontconfig
, freetype
, fribidi
, glib
, icu
, intltool
, libGL
, libGLU
, libX11
, libass
, libiconv
, libuchardet
, luajit
, pcre
, pkg-config
, which
, wxGTK
, zlib

, CoreText
, CoreFoundation
, AppKit
, Carbon
, IOKit
, Cocoa

, spellcheckSupport ? true
, hunspell ? null

, openalSupport ? false
, openal ? null

, alsaSupport ? stdenv.isLinux
, alsa-lib ? null

, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null

, portaudioSupport ? false
, portaudio ? null

, useBundledLuaJIT ? false
}:

assert spellcheckSupport -> (hunspell != null);
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
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "wangqr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oKhLv81EFudrJaaJ2ga3pVh4W5Hd2YchpjsoYoqRm78=";
  };

  nativeBuildInputs = [
    intltool
    luajit52
    pkg-config
    which
    cmake
  ];

  buildInputs = [
    boost
    expat
    ffmpeg
    ffms
    fftw
    fontconfig
    freetype
    fribidi
    glib
    harfbuzz
    icu
    libGL
    libGLU
    libX11
    libass
    libiconv
    libuchardet
    pcre
    wxGTK
    zlib
  ]
  ++ lib.optionals stdenv.isDarwin [
    CoreText
    CoreFoundation
    AppKit
    Carbon
    IOKit
    Cocoa
  ]
  ++ optional alsaSupport alsa-lib
  ++ optional openalSupport openal
  ++ optional portaudioSupport portaudio
  ++ optional pulseaudioSupport libpulseaudio
  ++ optional spellcheckSupport hunspell
  ;

  enableParallelBuilding = true;

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  patches = lib.optionals (!useBundledLuaJIT) [
    ./remove-bundled-luajit.patch
  ];

  NIX_CFLAGS_COMPILE = "-I${luajit52}/include";
  NIX_CFLAGS_LINK = "-L${luajit52}/lib";

  configurePhase = ''
    export FORCE_GIT_VERSION=${version}
    # Workaround for a Nixpkgs bug; remove when the fix arrives
    mkdir build-dir
    cd build-dir
    cmake -DCMAKE_INSTALL_PREFIX=$out ..
  '';

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
    platforms = platforms.unix;
  };
}
