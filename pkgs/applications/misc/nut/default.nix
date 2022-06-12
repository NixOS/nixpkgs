{ lib, stdenv, fetchurl, pkg-config, neon, libusb-compat-0_1, openssl, udev, avahi, freeipmi
, libtool, makeWrapper, autoreconfHook, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "nut";
  version = "2.7.4";

  src = fetchurl {
    url = "https://networkupstools.org/source/2.7/${pname}-${version}.tar.gz";
    sha256 = "19r5dm07sfz495ckcgbfy0pasx0zy3faa0q7bih69lsjij8q43lq";
  };

  patches = [
    (fetchpatch {
      # Fix build with openssl >= 1.1.0
      url = "https://github.com/networkupstools/nut/commit/612c05efb3c3b243da603a3a050993281888b6e3.patch";
      sha256 = "0jdbii1z5sqyv24286j5px65j7b3gp8zk3ahbph83pig6g46m3hs";
    })
  ];

  buildInputs = [ neon libusb-compat-0_1 openssl udev avahi freeipmi ];

  nativeBuildInputs = [ autoreconfHook libtool pkg-config makeWrapper ];

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

  NIX_CFLAGS_COMPILE = [ "-std=c++14" ];

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
