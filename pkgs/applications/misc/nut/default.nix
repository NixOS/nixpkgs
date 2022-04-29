{ lib, stdenv, fetchurl, pkg-config, neon, libusb-compat-0_1, openssl, udev, avahi, freeipmi
, libtool, makeWrapper, autoreconfHook, libmodbus, i2c-tools, net-snmp, gd
}:

stdenv.mkDerivation rec {
  pname = "nut";
  version = "2.8.0";

  src = fetchurl {
    url = "https://networkupstools.org/source/2.8/${pname}-${version}.tar.gz";
    sha256 = "1rdzjbvm6qyz9kz1jmdq0fszq0500q97plsknrq7qyvrv84agrf3";
  };

  buildInputs = [ neon libusb-compat-0_1 openssl udev avahi freeipmi libmodbus gd i2c-tools net-snmp ];

  nativeBuildInputs = [ autoreconfHook libtool pkg-config makeWrapper ];

  configureFlags =
    [ "--with-all"
      "--with-ssl"
      "--without-powerman" # Until we have it ...
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-systemdshutdowndir=$(out)/lib/systemd"
      "--with-systemdtmpfilesdir=$(out)/lib/tmpfiles.d"
      "--with-udev-dir=$(out)/etc/udev"
    ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/nut-scanner --prefix LD_LIBRARY_PATH : \
      "$out/lib:${neon}/lib:${libusb-compat-0_1.out}/lib:${avahi}/lib:${freeipmi}/lib"
  '';

  meta = with lib; {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = "https://networkupstools.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.pierron ];
    license = with licenses; [ gpl1Plus gpl2Plus gpl3Plus ];
    priority = 10;
  };
}
