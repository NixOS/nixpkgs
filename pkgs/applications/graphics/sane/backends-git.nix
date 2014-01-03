{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null, snapscanFirmware ? null
}:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.24.73-g6c4f6bc";

  src = fetchgit {
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
    rev = "6c4f6bc58615755dc734281703b594cea3ebf848";
    sha256 = "0f7lbv1rnr53n4rpihcd8dkfm01xvwfnx9i1nqaadrzbpvgkjrfa";
  };

  udevSupport = hotplugSupport;

  buildInputs = if libusb != null then [libusb] else [];

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
      " \${out}/share/sane/snapscan/your-firmwarefile.bin ;" +
      "mkdir -p \${out}/etc/sane.d ; " +
      "echo epson2 > \${out}/etc/sane.d/dll.conf"
    else "";

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
