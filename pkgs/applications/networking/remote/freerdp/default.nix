{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, alsaLib, ffmpeg, glib, openssl, pcre, zlib
, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama, libXrandr, libXrender, libXv, libXtst
, libxkbcommon, libxkbfile
, wayland
, gstreamer, gst-plugins-base, gst-plugins-good, libunwind, orc
, libxslt
, libusb1
, libpulseaudio ? null
, cups ? null
, pcsclite ? null
, systemd ? null
, buildServer ? true
, nocaps ? false
}:

stdenv.mkDerivation rec {
  pname = "freerdp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "FreeRDP";
    rev    = version;
    sha256 = "0d2559v0z1jnq6jlrvsgdf8p6gd27m8kwdnxckl1x0ygaxs50bqc";
  };

  # outputs = [ "bin" "out" "dev" ];

  prePatch = ''
    export HOME=$TMP
    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  '' + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  '';

  buildInputs = with lib; [
    alsaLib cups ffmpeg glib openssl pcre pcsclite libpulseaudio zlib
    gstreamer gst-plugins-base gst-plugins-good libunwind orc
    libX11 libXcursor libXdamage libXext libXi libXinerama libXrandr libXrender libXv libXtst
    libxkbcommon libxkbfile
    wayland libusb1
    libxslt
  ] ++ optional stdenv.isLinux systemd;

  nativeBuildInputs = [
    cmake pkgconfig
  ];

  enableParallelBuilding = true;

  doCheck = false;

  cmakeFlags = with lib; [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
    "-DWITH_OSS=OFF"
  ] ++ optional (libpulseaudio != null)       "-DWITH_PULSE=ON"
    ++ optional (cups != null)                "-DWITH_CUPS=ON"
    ++ optional (pcsclite != null)            "-DWITH_PCSC=ON"
    ++ optional buildServer                   "-DWITH_SERVER=ON"
    ++ optional (stdenv.isx86_64)             "-DWITH_SSE2=ON";

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = "http://www.freerdp.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg lheckemann ];
    platforms = platforms.unix;
  };
}
