{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null, snapscanFirmware ? null
}:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.25.177-g753d123";

  src = fetchgit {
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
    rev = "753d123f36d08cdb8047adac7c89a9fe015c4b25";
    sha256 = "1f5b4606f9b1b65a312794726e8d5d06056510b7426f86845ebeb8ca1a9b2f1f";
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

  meta = with stdenv.lib; {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ nckx simons ];
    platforms = platforms.linux;
  };
}
