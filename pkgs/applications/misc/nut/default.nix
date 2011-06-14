{stdenv, fetchurl, pkgconfig, neon, libusb, hal, openssl, udev}:

stdenv.mkDerivation {
  name = "nut-2.6.1";
  src = fetchurl {
    url = http://www.networkupstools.org/source/2.6/nut-2.6.1.tar.gz;
    sha256 = "f5c46b856c0cf5b7f0e4b22d82b670af64cc98717a90eaac8723dd402a181c00";
  };

  buildInputs = [pkgconfig neon libusb hal openssl udev];

  configureFlags = [
    "--with-all"
    "--without-snmp" # Until we have it ...
    "--without-powerman" # Until we have it ...
    "--without-cgi"
  ];

  meta = {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = http://www.networkupstools.org/;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers [ pierron ];
  };
}
