{ stdenv, fetchurl, fetchgit, libusb ? null, net_snmp ? null
, gt68xxFirmware ? null, snapscanFirmware ? null
, hotplugSupport ? true
}:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

let version = "2015-12-20"; in
stdenv.mkDerivation {
  name = "sane-backends-${version}";

  src = fetchgit {
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
    rev = "5136e664b8608604f54a2cc1d466019922b311e6";
    sha256 = "998fdc9cdd3f9220c38244e0b87bba3ee623d7d20726479b04ed95b3836a37ed";
  };

  udevSupport = hotplugSupport;

  buildInputs = [ net_snmp ]
    ++ stdenv.lib.optional (libusb != null) libusb;

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
    inherit version;
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
