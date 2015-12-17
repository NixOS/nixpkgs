{ stdenv, fetchurl
, avahi, libusb, libv4l, net_snmp
, pkgconfig
, gt68xxFirmware ? null, snapscanFirmware ? null
, hotplugSupport ? true
, version, src, ...
}:

assert hotplugSupport ->
  builtins.elem stdenv.system [ "i686-linux" "x86_64-linux" ];

let

  udevSupport = hotplugSupport;

in
stdenv.mkDerivation {
  inherit src;

  name = "sane-backends-${version}";

  outputs = [ "out" "doc" "man" ];

  configureFlags = []
    ++ stdenv.lib.optional (avahi != null) "--enable-avahi"
    ++ stdenv.lib.optional (libusb != null) "--enable-libusb_1_0";

  buildInputs = [ avahi libusb libv4l net_snmp ];
  nativeBuildInputs = [ pkgconfig ];

  postInstall = ''
    if test "$udevSupport" = "1"; then
      mkdir -p $out/etc/udev/rules.d/
      ./tools/sane-desc -m udev > $out/etc/udev/rules.d/49-libsane.rules || \
      cp tools/udev/libsane.rules $out/etc/udev/rules.d/49-libsane.rules
    fi
  '';

  preInstall =
    if gt68xxFirmware != null then
      "mkdir -p \${out}/share/sane/gt68xx ; ln -s " + gt68xxFirmware.fw +
      " \${out}/share/sane/gt68xx/" + gt68xxFirmware.name
    else if snapscanFirmware != null then
      "mkdir -p \${out}/share/sane/snapscan ; ln -s " + snapscanFirmware +
      " \${out}/share/sane/snapscan/your-firmwarefile.bin"
      "mkdir -p \${out}/etc/sane.d ; " +
      "echo epson2 >> \${out}/etc/sane.d/dll.conf"
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
