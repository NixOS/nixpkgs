{ stdenv, fetchurl
, avahi ? null, libusb ? null, libv4l ? null, net_snmp ? null
, pkgconfig ? null
, gt68xxFirmware ? null, snapscanFirmware ? null
, hotplugSupport ? true
}:

assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  version = "1.0.25";
  name = "sane-backends-${version}";

  src = fetchurl {
    urls = [
      "http://pkgs.fedoraproject.org/repo/pkgs/sane-backends/sane-backends-1.0.25.tar.gz/f9ed5405b3c12f07c6ca51ee60225fe7/${name}.tar.gz"
      "https://alioth.debian.org/frs/download.php/file/4146/${name}.tar.gz"
    ];
    curlOpts = "--insecure";
    sha256 = "0b3fvhrxl4l82bf3v0j47ypjv6a0k5lqbgknrq1agpmjca6vmmx4";
  };

  outputs = [ "out" "doc" "man" ];

  udevSupport = hotplugSupport;

  configureFlags = []
    ++ stdenv.lib.optional (avahi != null) "--enable-avahi"
    ++ stdenv.lib.optional (libusb != null) "--enable-libusb_1_0";

  buildInputs = [ avahi net_snmp ]
    ++ stdenv.lib.optional (libusb != null) libusb
    ++ stdenv.lib.optional (libv4l != null) libv4l
    ++ stdenv.lib.optional (pkgconfig != null) pkgconfig
    ;

  postInstall = ''
    if test "$udevSupport" = "1"; then
      mkdir -p $out/etc/udev/rules.d/
      ./tools/sane-desc -m udev > $out/etc/udev/rules.d/49-libsane.rules || \
      cp tools/udev/libsane.rules $out/etc/udev/rules.d/49-libsane.rules
    fi
  '';

  preInstall =
    if gt68xxFirmware != null then
      "mkdir -p \${out}/share/sane/gt68xx ; ln -s " + firmware.fw +
      " \${out}/share/sane/gt68xx/" + firmware.name
    else if snapscanFirmware != null then
      "mkdir -p \${out}/share/sane/snapscan ; ln -s " + snapscanFirmware +
      " \${out}/share/sane/snapscan/your-firmwarefile.bin"
    else "";

  meta = with stdenv.lib; {
    homepage = "http://www.sane-project.org/";
    description = "SANE (Scanner Access Now Easy) backends";
    longDescription = ''
      Collection of open-source SANE backends (device drivers).
      SANE is a universal scanner interface providing standardized access to
      any raster image scanner hardware: flatbed scanners, hand-held scanners,
      video- and still-cameras, frame-grabbers, etc. For a list of supported
      scanners, see http://www.sane-project.org/sane-backends.html.
    '';
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ nckx simons ];
    platforms = platforms.linux;
  };
}
