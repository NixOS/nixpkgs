{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  writableTmpDirAsHomeHook,
  docbook-xsl-nons,
  libxslt,
  pkg-config,
  glib,
  openssl,
  pcre2,
  pkcs11helper,
  zlib,
  libX11,
  libXcursor,
  libXdamage,
  libXdmcp,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  libXtst,
  libXv,
  libxkbcommon,
  libxkbfile,
  wayland,
  wayland-scanner,
  libunwind,
  orc,
  libusb1,
  systemd,
  buildServer ? true,
  nocaps ? false,
  withUnfree ? false,

  withJPEG ? true,
  libjpeg_turbo,

  withKerberos ? true,
  libkrb5,

  withURIParser ? stdenv.hostPlatform.isLinux,
  uriparser,

  withFFmpeg ? true,
  ffmpeg,

  withOpenH264 ? true,
  openh264,

  withGSM ? true,
  gsm,

  withAAC ? true,
  faad2,
  faac,

  withOpus ? true,
  libopus,

  withSoxr ? true,
  soxr,

  withCairo ? true,
  cairo,

  withAlsa ? stdenv.hostPlatform.isLinux,
  alsa-lib,

  withPulseAudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,

  withPrinting ? true,
  cups,

  withFuse ? stdenv.hostPlatform.isLinux,
  fuse3,

  withUnicode ? true,
  icu,

  withSmartCard ? true,
  pcsclite,

  withJSON ? true,
  cjson,

  withSDL ? true,
  SDL2,
  SDL2_ttf,
  SDL2_image,

  withWebview ? false,
  webkitgtk_4_1,

  # tries to compile and run generate_argument_docbook.c
  withManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  gnome-remote-desktop,
  remmina,
  testers,
  freerdp
}:

assert withURIParser -> stdenv.hostPlatform.isLinux;
assert withAlsa -> stdenv.hostPlatform.isLinux;
assert withPulseAudio -> stdenv.hostPlatform.isLinux;
assert withFuse -> stdenv.hostPlatform.isLinux;

stdenv.mkDerivation (finalAttrs: {
  pname = "freerdp";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = finalAttrs.version;
    hash = "sha256-KAlxpoGOqvHTqKkb/yMrquSckFfMXgbEfxr2IuLPZFQ=";
  };

  postPatch = ''
    # skip NIB file generation on darwin
    substituteInPlace "client/Mac/CMakeLists.txt" "client/Mac/cli/CMakeLists.txt" \
      --replace-fail "if(NOT IS_XCODE)" "if(FALSE)"

    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace-fail "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"

    substituteInPlace client/SDL/SDL2/dialogs/{sdl_input.cpp,sdl_select.cpp,sdl_widget.cpp,sdl_widget.hpp} \
      --replace-fail "<SDL_ttf.h>" "<SDL2/SDL_ttf.h>"
  ''
  + lib.optionalString withSmartCard ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace-fail "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  ''
  + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace-fail "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  '';

  nativeBuildInputs = [
    cmake
    libxslt
    docbook-xsl-nons
    pkg-config
    wayland-scanner
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    glib
    libX11
    libXcursor
    libXdamage
    libXdmcp
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    libXtst
    libXv
    libjpeg_turbo
    libkrb5
    libopus
    libunwind
    libusb1
    libxkbcommon
    libxkbfile
    openssl
    orc
    pcre2
    pkcs11helper
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemd
    wayland
    wayland-scanner
  ]
  ++ lib.optional withJPEG libjpeg_turbo
  ++ lib.optional withKerberos libkrb5
  ++ lib.optional withURIParser uriparser
  ++ lib.optional withFFmpeg ffmpeg
  ++ lib.optional withOpenH264 openh264
  ++ lib.optional withGSM gsm
  ++ lib.optional withAAC faad2
  ++ lib.optional (withUnfree && withAAC) faac
  ++ lib.optional withOpus libopus
  ++ lib.optional withSoxr soxr
  ++ lib.optional withCairo cairo
  ++ lib.optional withAlsa alsa-lib
  ++ lib.optional withPulseAudio libpulseaudio
  ++ lib.optional withPrinting cups
  ++ lib.optional withFuse fuse3
  ++ lib.optional withUnicode icu
  ++ lib.optional withSmartCard pcsclite
  ++ lib.optional withJSON cjson
  ++ lib.optionals withSDL [
    SDL2
    SDL2_ttf
    SDL2_image
  ]
  ++ lib.optional withWebview webkitgtk_4_1;

  # https://github.com/FreeRDP/FreeRDP/issues/8526#issuecomment-1357134746
  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "DOCBOOKXSL_DIR" "${docbook-xsl-nons}/xml/xsl/docbook")
  ]
  ++ lib.mapAttrsToList lib.cmakeBool {
    BUILD_TESTING = false; # false is recommended by upstream
    WITH_FFMPEG = withFFmpeg;
    WITH_SWSCALE = withFFmpeg;
    WITH_DSP_FFMPEG = withFFmpeg;
    WITH_CAIRO = withCairo;
    WITH_CUPS = withPrinting;
    CUPS = withPrinting;
    WITH_FAAC = withUnfree && withAAC;
    WITH_FAAD2 = withAAC;
    AAC = withAAC;
    WITH_FUSE = withFuse;
    FUSE = withFuse;
    ICU = withUnicode;
    WITH_UNICODE_BUILTIN = !withUnicode;
    WITH_JPEG = withJPEG;
    JPEG = withJPEG;
    WITH_KRB5 = withKerberos;
    WITH_OPENH264 = withOpenH264;
    WITH_OPUS = withOpus;
    OPUS = withOpus;
    WITH_OSS = false;
    WITH_MANPAGES = withManPages;
    WITH_PCSC = withSmartCard;
    PCSC = withSmartCard;
    WITH_PULSE = withPulseAudio;
    PULSE = withPulseAudio;
    WITH_SERVER = buildServer;
    WITH_WEBVIEW = withWebview;
    WITH_VAAPI = false; # false is recommended by upstream
    WITH_X11 = true;
  }
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    (lib.cmakeBool "SDL_USE_COMPILED_RESOURCES" false)
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-include AudioToolbox/AudioToolbox.h"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=incompatible-function-pointer-types"
    ]
  );

  passthru.tests = rec {
    version = testers.testVersion { package = freerdp; };
    # ensure we can build a minimal build, with none of the optional dependencies
    minimal = freerdp.override {
      withJPEG = false;
      withKerberos = false;
      withURIParser = false;
      withFFmpeg = false;
      withOpenH264 = false;
      withGSM = false;
      withAAC = false;
      withOpus = false;
      withSoxr = false;
      withCairo = false;
      withAlsa = false;
      withPulseAudio = false;
      withPrinting = false;
      withFuse = false;
      withUnicode = false;
      withSmartCard = false;
      withJSON = false;
      withSDL = false;
      withWebview = false;
      withManPages = false;
    };
    minimal-version = testers.testVersion { package = minimal; };
    inherit remmina;
    inherit gnome-remote-desktop;
  };

  meta = {
    description = "Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = "https://www.freerdp.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "xfreerdp";
  };
})
