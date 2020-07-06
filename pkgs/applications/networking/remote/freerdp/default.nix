{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, alsaLib, ffmpeg_3, glib, openssl
, pcre, zlib, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama
, libXrandr, libXrender, libXv, libXtst, libxkbcommon, libxkbfile, wayland
, gstreamer, gst-plugins-base, gst-plugins-good, libunwind, orc, libxslt
, libusb1, libpulseaudio ? null, cups ? null, pcsclite ? null, systemd ? null
, buildServer ? true, nocaps ? false }:

let
  cmFlag = flag: if flag then "ON" else "OFF";
  disabledTests = [
    # this one is probably due to our sandbox
    {
      dir = "libfreerdp/crypto/test";
      file = "Test_x509_cert_info.c";
    }
  ];

in stdenv.mkDerivation rec {
  pname = "freerdp";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = version;
    sha256 = "1yvi7zd0ic0rv7njd0wi9q1mfvz4d9qrx3i45dd6hcq465wg8dp7";
  };

  postPatch = ''
    export HOME=$TMP

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

  buildInputs = with lib;
    [
      alsaLib
      cups
      ffmpeg_3
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
      wayland
      zlib
    ] ++ optional stdenv.isLinux systemd;

  nativeBuildInputs = [ cmake pkgconfig ];

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
    };

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
