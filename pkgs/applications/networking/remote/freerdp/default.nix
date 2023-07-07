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
, glib
, openh264
, openssl
, pcre2
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
, gstreamer
, gst-plugins-base
, gst-plugins-good
, libunwind
, orc
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
, withUnfree ? false

# tries to compile and run generate_argument_docbook.c
, withManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform

, buildPackages
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

  inherit (lib) optionals;

in
stdenv.mkDerivation rec {
  pname = "freerdp";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = version;
    sha256 = "sha256-4sq3LblFRWCBREudtzg+o9wjstm58gPzBq7QAwlWvEg=";
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
    faad2
    ffmpeg
    glib
    gst-plugins-base
    gst-plugins-good
    gstreamer
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
    zlib
  ] ++ optionals stdenv.isLinux [
    alsa-lib
    systemd
    wayland
  ] ++ optionals stdenv.isDarwin [
    AudioToolbox
    AVFoundation
    Carbon
    Cocoa
    CoreMedia
  ]
  ++ optionals withUnfree [
    faac
  ];

  nativeBuildInputs = [
    cmake libxslt docbook-xsl-nons pkg-config
    wayland-scanner
  ];

  doCheck = true;

  # https://github.com/FreeRDP/FreeRDP/issues/8526#issuecomment-1357134746
  cmakeFlags = [
    "-Wno-dev"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DDOCBOOKXSL_DIR=${docbook-xsl-nons}/xml/xsl/docbook"
    "-DWAYLAND_SCANNER=${buildPackages.wayland-scanner}/bin/wayland-scanner"
  ]
  ++ lib.mapAttrsToList (k: v: "-D${k}=${cmFlag v}") {
    BUILD_TESTING = false; # false is recommended by upstream
    WITH_CAIRO = (cairo != null);
    WITH_CUPS = (cups != null);
    WITH_FAAC = (withUnfree && faac != null);
    WITH_FAAD2 = (faad2 != null);
    WITH_JPEG = (libjpeg_turbo != null);
    WITH_OPENH264 = (openh264 != null);
    WITH_OSS = false;
    WITH_MANPAGES = withManPages;
    WITH_PCSC = (pcsclite != null);
    WITH_PULSE = (libpulseaudio != null);
    WITH_SERVER = buildServer;
    WITH_VAAPI = false; # false is recommended by upstream
    WITH_X11 = true;
  };

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-DTARGET_OS_IPHONE=0"
    "-DTARGET_OS_WATCH=0"
    "-include AudioToolbox/AudioToolbox.h"
  ]);

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
