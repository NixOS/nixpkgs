{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null, snapscanFirmware ? null
}:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.25-180-g6d8b8d5";

  src = fetchgit {
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
    rev = "6d8b8d5aa6e8da2b24e1caa42b9ea75e9624b45d";
    sha256 = "b5b2786eef835550e4a4522db05c8c81075b1a7aff5a66f1d4a498f6efe0ef03";
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
