<<<<<<< HEAD
{ lib
, stdenv
, autoreconfHook
, avahi
, coreutils
, fetchurl
, freeipmi
, gd
, i2c-tools
, libmodbus
, libtool
, libusb1
, makeWrapper
, neon
, net-snmp
, openssl
, pkg-config
, substituteAll
, systemd
, udev
=======
{ lib, stdenv, fetchurl, substituteAll, pkg-config, neon, libusb-compat-0_1, openssl, udev, avahi, freeipmi
, libtool, makeWrapper, autoreconfHook, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "nut";
  version = "2.8.0";

  src = fetchurl {
    url = "https://networkupstools.org/source/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-w+WnCNp5e3xwtlPTexIGoAD8tQO4VRn+TN9jU/eSv+U=";
  };

  patches = [
=======
    sha256 = "19r5dm07sfz495ckcgbfy0pasx0zy3faa0q7bih69lsjij8q43lq";
  };

  patches = [
    (fetchpatch {
      # Fix build with openssl >= 1.1.0
      url = "https://github.com/networkupstools/nut/commit/612c05efb3c3b243da603a3a050993281888b6e3.patch";
      sha256 = "0jdbii1z5sqyv24286j5px65j7b3gp8zk3ahbph83pig6g46m3hs";
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (substituteAll {
      src = ./hardcode-paths.patch;
      avahi = "${avahi}/lib";
      freeipmi = "${freeipmi}/lib";
<<<<<<< HEAD
      libusb = "${libusb1}/lib";
      neon = "${neon}/lib";
      libmodbus = "${libmodbus}/lib";
      netsnmp = "${net-snmp.lib}/lib";
    })
  ];

  buildInputs = [ neon libusb1 openssl udev avahi freeipmi libmodbus i2c-tools net-snmp gd ];
=======
      libusb = "${libusb-compat-0_1}/lib";
      neon = "${neon}/lib";
    })
  ];

  buildInputs = [ neon libusb-compat-0_1 openssl udev avahi freeipmi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ autoreconfHook libtool pkg-config makeWrapper ];

  configureFlags =
    [ "--with-all"
      "--with-ssl"
<<<<<<< HEAD
      "--without-powerman" # Until we have it ...
      "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
      "--with-systemdshutdowndir=$(out)/lib/systemd/system-shutdown"
      "--with-systemdtmpfilesdir=$(out)/lib/tmpfiles.d"
=======
      "--without-snmp" # Until we have it ...
      "--without-powerman" # Until we have it ...
      "--without-cgi"
      "--without-hal"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "--with-udev-dir=$(out)/etc/udev"
    ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  postInstall = ''
    substituteInPlace $out/lib/systemd/system-shutdown/nutshutdown \
      --replace /bin/sleep "${coreutils}/bin/sleep" \
      --replace /bin/systemctl "${systemd}/bin/systemctl"

    for file in system/{nut-monitor.service,nut-driver-enumerator.service,nut-server.service,nut-driver@.service} system-shutdown/nutshutdown; do
    substituteInPlace $out/lib/systemd/$file \
      --replace "$out/etc/nut.conf" "/etc/nut.conf"
    done

    # we don't need init.d scripts
    rm -r $out/share/solaris-init
  '';
=======
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
