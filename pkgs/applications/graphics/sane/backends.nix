{ stdenv, fetchurl, hotplugSupport ? true, libusb ? null, libv4l ? null
, pkgconfig ? null, gt68xxFirmware ? null, snapscanFirmware ? null
}:

assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  version = "1.0.24";
  name = "sane-backends-${version}";

  src = fetchurl {
    urls = [
      "http://pkgs.fedoraproject.org/repo/pkgs/sane-backends/sane-backends-1.0.24.tar.gz/1ca68e536cd7c1852322822f5f6ac3a4/${name}.tar.gz"
      "https://alioth.debian.org/frs/download.php/file/3958/${name}.tar.gz"
    ];
    curlOpts = "--insecure";
    sha256 = "0ba68m6bzni54axjk15i51rya7hfsdliwvqyan5msl7iaid0iir7";
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
    else if snapscanFirmware != null then
      "mkdir -p \${out}/share/sane/snapscan ; ln -s " + snapscanFirmware +
      " \${out}/share/sane/snapscan/your-firmwarefile.bin"
    else "";

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
