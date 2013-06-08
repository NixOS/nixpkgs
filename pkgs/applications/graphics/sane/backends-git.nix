{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null, gt68xxFirmware ? null }:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.22.482-g071f226";

  src = fetchgit {
    url = "http://git.debian.org/git/sane/sane-backends.git";
    rev = "071f2269cd68d3411cbfa05a3d028b74496db970";
    sha256 = "178xkv30m6irk4k0gqnfcl5kramm1qyj24dar8gp32428z1444xf";
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
    else "";

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
