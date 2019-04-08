{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, alsaLib, ffmpeg, glib, openssl, pcre, zlib
, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama, libXrandr, libXrender, libXv
, libxkbcommon, libxkbfile
, wayland
, gstreamer, gst-plugins-base, gst-plugins-good, libunwind, orc
, libpulseaudio ? null
, cups ? null
, pcsclite ? null
, systemd ? null
, buildServer ? true
, optimize ? true
}:

stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "2.0.0-rc4";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "FreeRDP";
    rev    = version;
    sha256 = "0546i0m2d4nz5jh84ngwzpcm3c43fp987jk6cynqspsmvapab6da";
  };

  # outputs = [ "bin" "out" "dev" ];

  prePatch = ''
    export HOME=$TMP
    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace "libpcsclite.so" "${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so"
  '';

  buildInputs = with lib; [
    alsaLib cups ffmpeg glib openssl pcre pcsclite libpulseaudio zlib
    gstreamer gst-plugins-base gst-plugins-good libunwind orc
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
  ] ++ optional (libpulseaudio != null)       "-DWITH_PULSE=ON"
    ++ optional (cups != null)                "-DWITH_CUPS=ON"
    ++ optional (pcsclite != null)            "-DWITH_PCSC=ON"
    ++ optional buildServer                   "-DWITH_SERVER=ON"
    ++ optional (optimize && stdenv.isx86_64) "-DWITH_SSE2=ON";

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = http://www.freerdp.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
