{ stdenv, fetchurl, pkgconfig, neon, libusb, openssl, udev, avahi, freeipmi }:

stdenv.mkDerivation {
  name = "nut-2.6.3";
  src = fetchurl {
    url = http://www.networkupstools.org/source/2.6/nut-2.6.3.tar.gz;
    sha256 = "0fk3bcivv26kw1psxb6sykqp9n5w02j01s1idypzlci0kmr3p49l";
  };

  buildInputs = [ neon libusb openssl udev avahi freeipmi ];
  buildNativeInputs = [ pkgconfig ];

  configureFlags = [
    "--with-all"
    "--with-ssl"
    "--without-snmp" # Until we have it ...
    "--without-powerman" # Until we have it ...
    "--without-cgi"
    "--without-hal"
  ];

  meta = {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = http://www.networkupstools.org/;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ pierron ];
    priority = 10;
  };
}
