{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, zlib, libX11, libXcursor
, libXdamage, libXext, glib, alsaLib, ffmpeg, libxkbfile, libXinerama, libXv
, pulseaudio ? null, cups ? null, pcsclite ? null
}:

stdenv.mkDerivation rec {
  name = "freerdp-1.2.0-beta1";

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP";
    rev = "1.2.0-beta1+android7";
    sha256 = "08nn18jydblrif1qs92pakzd3ww7inr0i378ssn1bjp09lm1bkk0";
  };

  buildInputs = [
    cmake pkgconfig openssl zlib libX11 libXcursor libXdamage libXext glib
    alsaLib ffmpeg libxkbfile libXinerama libXv cups pulseaudio pcsclite
  ];

  doCheck = false;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
  ] ++ stdenv.lib.optional (pulseaudio != null) "-DWITH_PULSE=ON"
    ++ stdenv.lib.optional (cups != null) "-DWITH_CUPS=ON"
    ++ stdenv.lib.optional (pcsclite != null) "-DWITH_PCSC=ON";

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

