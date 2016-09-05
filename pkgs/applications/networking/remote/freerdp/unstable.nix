{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, zlib
, libX11, libXcursor, libXdamage, libXext, libXrender, libxkbfile, libXinerama, libXv
, glib, alsaLib, ffmpeg, substituteAll, wayland
, libpulseaudio ? null, cups ? null, pcsclite ? null
, buildServer ? true, optimize ? true
}:

stdenv.mkDerivation rec {
  name = "freerdp-1.2.0-20160107";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = "c3ce0c3b09bf10f388011e01bb4091e351af39e9";
    sha256 = "0m8yqs4acj8jga1zxifba8zwmasgff5l0fmgb0iwzczp8wwj36rw";
  };

  patches = [
  ] ++ stdenv.lib.optional (pcsclite != null)
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit pcsclite;
      });

  buildInputs = [
    cmake pkgconfig openssl zlib libX11 libXcursor libXdamage libXext libXrender glib
    alsaLib ffmpeg libxkbfile libXinerama libXv cups libpulseaudio pcsclite
    wayland
  ];

  doCheck = false;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
    "-DWITH_WAYLAND=ON"
  ] ++ stdenv.lib.optional (libpulseaudio != null) "-DWITH_PULSE=ON"
    ++ stdenv.lib.optional (cups != null) "-DWITH_CUPS=ON"
    ++ stdenv.lib.optional (pcsclite != null) "-DWITH_PCSC=ON"
    ++ stdenv.lib.optional buildServer "-DWITH_SERVER=ON"
    ++ stdenv.lib.optional optimize "-DWITH_SSE2=ON";


  meta = with stdenv.lib; {
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
