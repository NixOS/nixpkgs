{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null, gt68xxFirmware ? null, snapscanFirmware ? null }:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.23.296-gf139120";

  src = fetchgit {
    url = "http://git.debian.org/git/sane/sane-backends.git";
    rev = "f139120c72db6de98be95b52c206c2a4d8071e92";
    sha256 = "1b2fv19c8ijh9l0jjilli3j70n17wvcgpqq1nxmiby3ai6nrzk8d";
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
