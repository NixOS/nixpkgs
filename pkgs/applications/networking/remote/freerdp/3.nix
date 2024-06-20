{ stdenv
, lib
, fetchFromGitHub
, cmake
, docbook-xsl-nons
, libxslt
, pkg-config
, alsa-lib
, faac
, faad2
, ffmpeg
, fuse3
, glib
, openh264
, openssl
, pcre2
, pkcs11helper
, uriparser
, zlib
, libX11
, libXcursor
, libXdamage
, libXdmcp
, libXext
, libXi
, libXinerama
, libXrandr
, libXrender
, libXtst
, libXv
, libxkbcommon
, libxkbfile
, wayland
, wayland-scanner
, icu
, libunwind
, orc
, cairo
, cjson
, libusb1
, libpulseaudio
, cups
, pcsclite
, SDL2
, SDL2_ttf
, SDL2_image
, systemd
, libjpeg_turbo
, libkrb5
, libopus
, buildServer ? true
, nocaps ? false
, AudioToolbox
, AVFoundation
, Carbon
, Cocoa
, CoreMedia
, withUnfree ? false

  # tries to compile and run generate_argument_docbook.c
, withManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform

, buildPackages
}:

let
  cmFlag = flag: if flag then "ON" else "OFF";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freerdp";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = finalAttrs.version;
    hash = "sha256-8yWMnwJbvyUiEuX+2bEim1IeqPx20u9yvNIVe7MC/ZQ=";
  };

  postPatch = ''
    export HOME=$TMP

    # skip NIB file generation on darwin
    substituteInPlace "client/Mac/CMakeLists.txt" "client/Mac/cli/CMakeLists.txt" \
      --replace-fail "if (NOT IS_XCODE)" "if (FALSE)"

    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace-fail "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace-fail "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  '' + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace-fail "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  '';

  nativeBuildInputs = [
    cmake
    libxslt
    docbook-xsl-nons
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    cjson
    cups
    faad2
    ffmpeg
    glib
    icu
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
    SDL2
    SDL2_ttf
    SDL2_image
    uriparser
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    fuse3
    systemd
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
    AudioToolbox
    AVFoundation
    Carbon
    Cocoa
    CoreMedia
  ] ++ lib.optionals withUnfree [
    faac
  ];

  # https://github.com/FreeRDP/FreeRDP/issues/8526#issuecomment-1357134746
  cmakeFlags = [
    "-Wno-dev"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DDOCBOOKXSL_DIR=${docbook-xsl-nons}/xml/xsl/docbook"
    "-DWAYLAND_SCANNER=${buildPackages.wayland-scanner}/bin/wayland-scanner"
  ] ++ lib.mapAttrsToList (k: v: "-D${k}=${cmFlag v}") {
    BUILD_TESTING = false; # false is recommended by upstream
    WITH_CAIRO = (cairo != null);
    WITH_CUPS = (cups != null);
    WITH_FAAC = (withUnfree && faac != null);
    WITH_FAAD2 = (faad2 != null);
    WITH_FUSE = (stdenv.isLinux && fuse3 != null);
    WITH_JPEG = (libjpeg_turbo != null);
    WITH_KRB5 = (libkrb5 != null);
    WITH_OPENH264 = (openh264 != null);
    WITH_OPUS = (libopus != null);
    WITH_OSS = false;
    WITH_MANPAGES = withManPages;
    WITH_PCSC = (pcsclite != null);
    WITH_PULSE = (libpulseaudio != null);
    WITH_SERVER = buildServer;
    WITH_WEBVIEW = false; # avoid introducing webkit2gtk-4.0
    WITH_VAAPI = false; # false is recommended by upstream
    WITH_X11 = true;
  };

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-DTARGET_OS_IPHONE=0"
    "-DTARGET_OS_WATCH=0"
    "-include AudioToolbox/AudioToolbox.h"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=incompatible-function-pointer-types"
  ]);

  env.NIX_LDFLAGS = toString (lib.optionals stdenv.isDarwin [
    "-framework AudioToolbox"
  ]);

  meta = with lib; {
    description = "Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = "https://www.freerdp.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg lheckemann ];
    platforms = platforms.unix;
  };
})
