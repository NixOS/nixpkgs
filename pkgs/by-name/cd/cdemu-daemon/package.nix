{
  stdenv,
  cmake,
  pkg-config,
  glib,
  libao,
  intltool,
  libmirage,
  coreutils,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdemu-daemon";
  version = "3.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/cdemu-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-EKh2G6RA9Yq46BpTAqN2s6TpLJb8gwDuEpGiwdGcelc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
  ];
  buildInputs = [
    glib
    libao
    libmirage
  ];
  postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cp -R ../service-example $out/share/cdemu
    substitute \
      $out/share/cdemu/net.sf.cdemu.CDEmuDaemon.service \
      $out/share/dbus-1/services/net.sf.cdemu.CDEmuDaemon.service \
      --replace /bin/true ${coreutils}/bin/true
  '';

  meta = {
    description = "Suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = "https://cdemu.sourceforge.io/about/daemon/";
    mainProgram = "cdemu-daemon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
})
