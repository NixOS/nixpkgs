{ stdenv, fetchurl, pkgconfig, neon, libusb, openssl, udev, avahi, freeipmi }:

stdenv.mkDerivation rec {
  name = "nut-2.6.5";

  src = fetchurl {
    url = "http://www.networkupstools.org/source/2.6/${name}.tar.gz";
    sha256 = "0gxrzsblx0jc4g9w0903ybwqbv1d79vq5hnks403fvnay4fgg3b1";
  };

  buildInputs = [ neon libusb openssl udev avahi freeipmi ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--with-all"
      "--with-ssl"
      "--without-snmp" # Until we have it ...
      "--without-powerman" # Until we have it ...
      "--without-cgi"
      "--without-hal"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/systemd"
    ];

  enableParallelBuilding = true;

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
