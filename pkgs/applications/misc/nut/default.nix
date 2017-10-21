{ stdenv, fetchurl, pkgconfig, neon, libusb, openssl, udev, avahi, freeipmi
, libtool, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nut-2.7.4";

  src = fetchurl {
    url = "http://www.networkupstools.org/source/2.7/${name}.tar.gz";
    sha256 = "19r5dm07sfz495ckcgbfy0pasx0zy3faa0q7bih69lsjij8q43lq";
  };

  buildInputs = [ neon libusb openssl udev avahi freeipmi libtool ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  configureFlags =
    [ "--with-all"
      "--with-ssl"
      "--without-snmp" # Until we have it ...
      "--without-powerman" # Until we have it ...
      "--without-cgi"
      "--without-hal"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-udev-dir=$(out)/etc/udev"
    ];

  enableParallelBuilding = true;


  postInstall = ''
    wrapProgram $out/bin/nut-scanner --prefix LD_LIBRARY_PATH : \
      "$out/lib:${neon}/lib:${libusb.out}/lib:${avahi}/lib:${freeipmi}/lib"
  '';

  meta = {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = http://www.networkupstools.org/;
    repositories.git = https://github.com/networkupstools/nut.git;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ pierron ];
    priority = 10;
  };
}
