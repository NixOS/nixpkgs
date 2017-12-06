{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, alsaLib, ffmpeg_2, glib, openssl, pcre, zlib
, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama, libXrandr, libXrender, libXv
, libxkbcommon, libxkbfile
, wayland
, gstreamer, gst-plugins-base, gst-plugins-good
, libpulseaudio ? null
, cups ? null
, pcsclite ? null
, systemd ? null
, buildServer ? true
, optimize ? true
}:

stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "2.0.0-rc1";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "FreeRDP";
    rev    = version;
    sha256 = "0m28n3mq3ax0j6j3ai4pnlx3shg2ap0md0bxlqkhfv6civ9r11nn";
  };

  # outputs = [ "bin" "out" "dev" ];

  prePatch = ''
    export HOME=$TMP
    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace "libpcsclite.so" "${pcsclite}/lib/libpcsclite.so"
  '';

  buildInputs = with lib; [
    alsaLib cups ffmpeg_2 glib openssl pcre pcsclite libpulseaudio zlib
    gstreamer gst-plugins-base gst-plugins-good
    libX11 libXcursor libXdamage libXext libXi libXinerama libXrandr libXrender libXv
    libxkbcommon libxkbfile
    wayland
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
  ] ++ optional (libpulseaudio != null) "-DWITH_PULSE=ON"
    ++ optional (cups != null)          "-DWITH_CUPS=ON"
    ++ optional (pcsclite != null)      "-DWITH_PCSC=ON"
    ++ optional buildServer             "-DWITH_SERVER=ON"
    ++ optional optimize                "-DWITH_SSE2=ON";

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = http://www.freerdp.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ wkennington peterhoeg ];
    platforms = platforms.unix;
  };
}
