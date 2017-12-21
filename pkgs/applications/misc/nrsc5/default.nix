{ stdenv, lib, fetchFromGitHub,
  autoconf, automake, libtool, cmake,
  rtl-sdr, libao, fftwFloat, faad2-hdc
} :

stdenv.mkDerivation {
  name = "nrsc5-20171129";

  src = fetchFromGitHub {
    owner = "theori-io";
    repo = "nrsc5";
    rev = "f87beeed96f12ce6aa4789ac1d45761cec28d2db";
    sha256 = "03d5k59125qrjsm1naj9pd0nfzwi008l9n30p9q4g5abgqi5nc8v";
  };

  patches = [ ./faad2-external-pkg.patch ];

  nativeBuildInputs = [ cmake autoconf automake libtool libao.dev ];
  buildInputs = [ rtl-sdr libao fftwFloat faad2-hdc ];

  cmakeFlags = [ "-DUSE_COLOR=ON" "-DUSE_FAAD2=ON" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/theori-io/nrsc5;
    description = "HD-Radio decoder for RTL-SDR";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ markuskowa ];
  };
}

