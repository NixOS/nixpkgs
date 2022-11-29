{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, ffmpeg
, glib
, openssl
, pcre
, zlib
, libX11
, libXcursor
, libXdamage
, libXext
, libXi
, libXinerama
, libXrandr
, libXrender
, libXv
, libXtst
, libxkbcommon
, libxkbfile
, wayland
, gstreamer
, gst-plugins-base
, gst-plugins-good
, libunwind
, orc
, libxslt
, cairo
, libusb1
, libpulseaudio
, cups
, pcsclite
, systemd
, libjpeg_turbo
, buildServer ? true
, nocaps ? false
, AudioToolbox
, AVFoundation
, Carbon
, Cocoa
, CoreMedia
}:

let
  cmFlag = flag: if flag then "ON" else "OFF";
  disabledTests = [
    # this one is probably due to our sandbox
    {
      dir = "libfreerdp/crypto/test";
      file = "Test_x509_cert_info.c";
    }
  ] ++ lib.optionals stdenv.isDarwin [
    {
      dir = "winpr/libwinpr/sysinfo/test";
      file = "TestGetComputerName.c";
    }
  ];

in
stdenv.mkDerivation rec {
  pname = "freerdp";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = version;
    sha256 = "sha256-I9xJWHoY8fZ5T9zca77gFciC+7JdD6fMwV16giiY4FU=";
  };

  postPatch = ''
    export HOME=$TMP

    # skip NIB file generation on darwin
    sed -z 's/NIB file generation.*//' -i client/Mac{,/cli}/CMakeLists.txt

    # failing test(s)
    ${lib.concatMapStringsSep "\n" (e: ''
      substituteInPlace ${e.dir}/CMakeLists.txt \
        --replace ${e.file} ""
      rm ${e.dir}/${e.file}
    '') disabledTests}

    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  '' + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  '';

  buildInputs = [
    cairo
    cups
    ffmpeg
    glib
    gst-plugins-base
    gst-plugins-good
    gstreamer
    libX11
    libXcursor
    libXdamage
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    libXtst
    libXv
    libjpeg_turbo
    libpulseaudio
    libunwind
    libusb1
    libxkbcommon
    libxkbfile
    libxslt
    openssl
    orc
    pcre
    pcsclite
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    systemd
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
    AudioToolbox
    AVFoundation
    Carbon
    Cocoa
    CoreMedia
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  doCheck = true;

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ]
    ++ lib.mapAttrsToList (k: v: "-D${k}=${if v then "ON" else "OFF"}") {
    BUILD_TESTING = doCheck;
    WITH_CUNIT = doCheck;
    WITH_CUPS = (cups != null);
    WITH_OSS = false;
    WITH_PCSC = (pcsclite != null);
    WITH_PULSE = (libpulseaudio != null);
    WITH_SERVER = buildServer;
    WITH_SSE2 = stdenv.isx86_64;
    WITH_VAAPI = true;
    WITH_JPEG = (libjpeg_turbo != null);
    WITH_CAIRO = (cairo != null);
    WITH_X11 = true;
  };

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin [
    "-DTARGET_OS_IPHONE=0"
    "-DTARGET_OS_WATCH=0"
    "-include AudioToolbox/AudioToolbox.h"
  ];

  NIX_LDFLAGS = lib.optionals stdenv.isDarwin [
    "-framework AudioToolbox"
  ];

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = "https://www.freerdp.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg lheckemann ];
    platforms = platforms.unix;
  };
}
