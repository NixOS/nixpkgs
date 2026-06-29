{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  writableTmpDirAsHomeHook,
  docbook-xsl-nons,
  libxslt,
  pkg-config,
  alsa-lib,
  faac,
  faad2,
  ffmpeg,
  fuse3,
  glib,
  openh264,
  openssl,
  pcre2,
  pkcs11helper,
  uriparser,
  zlib,
  libx11,
  libxcursor,
  libxdamage,
  libxdmcp,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxtst,
  libxv,
  libxkbcommon,
  libxkbfile,
  wayland,
  wayland-scanner,
  icu,
  libunwind,
  orc,
  cairo,
  cjson,
  libcbor,
  libfido2,
  libusb1,
  libpulseaudio,
  cups,
  pcsclite,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  sdl3,
  sdl3-ttf,
  sdl3-image,
  wrapGAppsHook3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  systemd,
  libjpeg_turbo,
  libkrb5,
  libopus,
  buildServer ? true,
  nocaps ? false,
  withUnfree ? false,
  withWaylandSupport ? false,
  withSDL2 ? false,
  withWebView ? false,
  makeWrapper,

  # tries to compile and run generate_argument_docbook.c
  withManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  gnome-remote-desktop,
  remmina,
  nix-update-script,
}:
let
  webview = fetchFromGitHub {
    owner = "akallabeth";
    repo = "webview";
    rev = "2a0a1303c5e8c9c5b73fa9e461739042ebdabe6f"; # https://github.com/akallabeth/webview/commits/navigation-listener/
    hash = "sha256-gT6lZCA++dbQZMWwbAfZyJqJ6hEIm7SW7eKLAWDLS/U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freerdp";
  version = "3.27.1";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    tag = finalAttrs.version;
    hash = "sha256-4U3QC1hka+qTQ0F7GqKPiMVwkkFeJvbjNtom5A7V/Sg=";
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
  + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace-fail "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  ''
  + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace-fail "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  ''
  + lib.optionalString withWebView ''
    mkdir -p external
    ln -s ${webview} external/webview
  '';

  nativeBuildInputs = [
    cmake
    libxslt
    docbook-xsl-nons
    pkg-config
    wayland-scanner
    writableTmpDirAsHomeHook
    makeWrapper
  ]
  ++ lib.optionals withWebView [
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    cjson
    cups
    faad2
    ffmpeg
    glib
    icu
    libcbor
    libfido2
    libx11
    libxcursor
    libxdamage
    libxdmcp
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    libxtst
    libxv
    libjpeg_turbo
    libkrb5
    libopus
    libpulseaudio
    libunwind
    libusb1
    libxkbcommon
    libxkbfile
    openh264
    openssl
    orc
    pcre2
    pcsclite
    pkcs11helper
    sdl3
    sdl3-ttf
    sdl3-image
    uriparser
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fuse3
    systemd
    wayland
    wayland-scanner
  ]
  ++ lib.optionals withSDL2 [
    SDL2
    SDL2_ttf
    SDL2_image
  ]
  ++ lib.optionals withWebView [
    webkitgtk_4_1
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ]
  ++ lib.optionals withUnfree [
    faac
  ];

  # https://github.com/FreeRDP/FreeRDP/issues/8526#issuecomment-1357134746
  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "DOCBOOKXSL_DIR" "${docbook-xsl-nons}/xml/xsl/docbook")
  ]
  ++ lib.mapAttrsToList lib.cmakeBool (
    {
      BUILD_TESTING = false; # false is recommended by upstream
      CHANNEL_RDPEWA = true;
      CHANNEL_RDPEWA_CLIENT = true;
      WITH_CAIRO = cairo != null;
      WITH_CUPS = cups != null;
      WITH_FAAC = withUnfree && faac != null;
      WITH_FAAD2 = faad2 != null;
      WITH_FUSE = stdenv.hostPlatform.isLinux && fuse3 != null;
      WITH_JPEG = libjpeg_turbo != null;
      WITH_KRB5 = libkrb5 != null;
      WITH_OPENH264 = openh264 != null;
      WITH_OPUS = libopus != null;
      WITH_OSS = false;
      WITH_MANPAGES = withManPages;
      WITH_PCSC = pcsclite != null;
      WITH_PULSE = libpulseaudio != null;
      WITH_SERVER = buildServer;
      WITH_WEBVIEW = withWebView;
      WITH_VAAPI = false; # false is recommended by upstream
    }
    // lib.filterAttrs (name: value: value) {
      # Only select one
      WITH_X11 = !withWaylandSupport;
      WITH_WAYLAND = withWaylandSupport;
    }
  )
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

  postFixup = lib.optionalString (withWaylandSupport && withSDL2) ''
    wrapProgram $out/bin/sdl2-freerdp \
      --set SDL_VIDEODRIVER wayland
  '';

  passthru = {
    tests = {
      inherit gnome-remote-desktop remmina;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    changelog = "https://github.com/FreeRDP/FreeRDP/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://www.freerdp.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cizra
      deimelias
    ];
    platforms = lib.platforms.unix;
  };
})
