{
  lib,
  alsa-lib,
  boost,
  cmake,
  config,
  darwin,
  expat,
  fetchFromGitHub,
  fetchpatch,
  ffmpeg,
  ffms,
  fftw,
  fontconfig,
  freetype,
  fribidi,
  glib,
  harfbuzz,
  hunspell,
  icu,
  intltool,
  libGL,
  libGLU,
  libX11,
  libass,
  libiconv,
  libpulseaudio,
  libuchardet,
  luajit,
  ninja,
  openal,
  pcre,
  pkg-config,
  portaudio,
  stdenv,
  which,
  wrapGAppsHook3,
  wxGTK,
  zlib,
  # Boolean guard flags
  alsaSupport ? stdenv.isLinux,
  openalSupport ? true,
  portaudioSupport ? true,
  pulseaudioSupport ? config.pulseaudio or stdenv.isLinux,
  spellcheckSupport ? true,
  useBundledLuaJIT ? false,
}:

let
  inherit (darwin.apple_sdk.frameworks)
    AppKit
    Carbon
    Cocoa
    CoreFoundation
    CoreText
    IOKit
    OpenAL;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aegisub";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "wangqr";
    repo = "aegisub";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oKhLv81EFudrJaaJ2ga3pVh4W5Hd2YchpjsoYoqRm78=";
  };

  nativeBuildInputs = [
    cmake
    intltool
    luajit
    ninja
    pkg-config
    which
    wrapGAppsHook3
    wxGTK
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
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals openalSupport [
    (if stdenv.isDarwin then OpenAL else openal)
  ]
  ++ lib.optionals portaudioSupport [ portaudio ]
  ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
  ++ lib.optionals spellcheckSupport [ hunspell ]
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    Carbon
    Cocoa
    CoreFoundation
    CoreText
    IOKit
  ];

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  patches = [
    (fetchpatch {
      name = "move-iconv-include-to-charset_conv.h.patch";
      url = "https://github.com/arch1t3cht/Aegisub/commit/b8f4c98c4cbc698e4adbba302c2dc328fe193435.patch";
      hash = "sha256-dCm/VG+8yK7qWKWF4Ew/M2hbbAC/d3hiuRglR9BvWtw=";
    })
  ] ++ lib.optionals (!useBundledLuaJIT) [
    ./000-remove-bundled-luajit.patch
  ];

  # error: unknown type name 'NSUInteger'
  postPatch = ''
    substituteInPlace src/dialog_colorpicker.cpp \
      --replace "NSUInteger" "size_t"
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev luajit}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib luajit}/lib";
  };

  preConfigure = ''
    export FORCE_GIT_VERSION=${finalAttrs.version}
  '';

  cmakeBuildDir = "build-directory";

  strictDeps = true;

  meta = {
    homepage = "https://github.com/wangqr/Aegisub";
    description = "Advanced subtitle editor; wangqr's fork";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # softwares - so the resulting program will be GPL
    license = with lib.licenses; [
      bsd3
    ];
    mainProgram = "aegisub";
    maintainers = with lib.maintainers; [ AndersonTorres wegank ];
    platforms = lib.platforms.unix;
  };
})
