{ stdenv, fetchFromGitHub, pkgconfig, libusb, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090";
  version = "2014-10-31";

  src = fetchFromGitHub {
    owner = "MalcolmRobb";
    repo = pname;
    rev = "bff92c4ad772a0a8d433f788d39dae97e00e4dbe";
    sha256 = "06aaj9gpz5v4qzvnp8xf18wdfclp0jvn3hflls79ly46gz2dh9hy";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libusb rtl-sdr ];

  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090
  '';

  meta = with stdenv.lib; {
    description = "A simple Mode S decoder for RTLSDR devices";
    homepage = https://github.com/MalcolmRobb/dump1090;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ earldouglas ];
  };
}
