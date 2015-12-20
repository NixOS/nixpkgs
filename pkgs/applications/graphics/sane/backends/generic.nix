{ stdenv, fetchurl
, avahi ? null, libusb ? null, libv4l ? null, net_snmp ? null
, pkgconfig
, gt68xxFirmware ? null, snapscanFirmware ? null
, hotplugSupport ? true
, version, src, ...
}:

assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

let

  firmware = gt68xxFirmware { inherit fetchurl; };

  udevSupport = hotplugSupport;

in
stdenv.mkDerivation {
  inherit src;

  name = "sane-backends-${version}";

  outputs = [ "out" "doc" "man" ];

  configureFlags = []
    ++ stdenv.lib.optional (avahi != null) "--enable-avahi"
    ++ stdenv.lib.optional (libusb != null) "--enable-libusb_1_0";

  buildInputs = [ avahi net_snmp pkgconfig ]
    ++ stdenv.lib.optional (libusb != null) libusb
    ++ stdenv.lib.optional (libv4l != null) libv4l
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
    inherit version;

    description = "SANE (Scanner Access Now Easy) backends";
    longDescription = ''
      Collection of open-source SANE backends (device drivers).
      SANE is a universal scanner interface providing standardized access to
      any raster image scanner hardware: flatbed scanners, hand-held scanners,
      video- and still-cameras, frame-grabbers, etc. For a list of supported
      scanners, see http://www.sane-project.org/sane-backends.html.
    '';
    homepage = "http://www.sane-project.org/";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ nckx simons ];
    platforms = platforms.linux;
  };
}
