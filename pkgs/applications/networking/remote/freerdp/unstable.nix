{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, zlib, libX11, libXcursor
, libXdamage, libXext, glib, alsaLib, ffmpeg, libxkbfile, libXinerama, libXv
, substituteAll
, libpulseaudio ? null, cups ? null, pcsclite ? null
, buildServer ? true, optimize ? true
}:

stdenv.mkDerivation rec {
  name = "freerdp-2.0-dev";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = "1855e36179fb197e713d41c4ef93e19cf1f0be2f";
    sha256 = "1lydkh6by0sjy6dl57bzg7c11ccyp24s80pwxw9h5kmxkbw6mx5q";
  };

  patches = [
  ] ++ stdenv.lib.optional (pcsclite != null)
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit pcsclite;
      });

  buildInputs = [
    cmake pkgconfig openssl zlib libX11 libXcursor libXdamage libXext glib
    alsaLib ffmpeg libxkbfile libXinerama libXv cups libpulseaudio pcsclite
  ];

  doCheck = false;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
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
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}

