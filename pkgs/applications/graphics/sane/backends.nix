{ stdenv, fetchurl, hotplugSupport ? true, libusb ? null, libv4l ? null, pkgconfig ? null , gt68xxFirmware ? null }:

assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  version = "1.0.23";
  name = "sane-backends-${version}";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/sane-backends_${version}.orig.tar.gz";
    sha256 = "4d4f5b2881615af7fc0ed75fdde7dc623a749e80e40f3f792fe4010163cbb029";
  };

  udevSupport = hotplugSupport;

  configureFlags = stdenv.lib.optional (libusb != null) "--enable-libusb_1_0";

  buildInputs = []
    ++ stdenv.lib.optional (libusb != null) libusb
    ++ stdenv.lib.optional (libv4l != null) libv4l
    ++ stdenv.lib.optional (pkgconfig != null) pkgconfig
    ;

  postInstall = ''
    if test "$udevSupport" = "1"; then
      mkdir -p $out/etc/udev/rules.d/
      ./tools/sane-desc -m udev > $out/etc/udev/rules.d/60-libsane.rules || \
      cp tools/udev/libsane.rules $out/etc/udev/rules.d/60-libsane.rules
    fi
  '';

  preInstall =
    if gt68xxFirmware != null then
      "mkdir -p \${out}/share/sane/gt68xx ; ln -s " + firmware.fw +
      " \${out}/share/sane/gt68xx/" + firmware.name
    else "";

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
