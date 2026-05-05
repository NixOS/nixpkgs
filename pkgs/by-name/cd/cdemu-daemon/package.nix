{
  stdenv,
  cmake,
  pkg-config,
  glib,
  libao,
  intltool,
  libmirage,
  coreutils,
  fetchurl,
  lib,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdemu-daemon";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/cdemu-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-AYHjiOAQdu685gc6p0j2QNtCmTYTWix1kzWQZYvGPWU=";
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

  passthru = {
    updateScript = writeScript "update-cdemu-daemon" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Fetch the latest version from the SourceForge RSS feed for cdemu-daemon
      newVersion="$(curl -s "https://sourceforge.net/projects/cdemu/rss?path=/cdemu-daemon" | pcre2grep -o1 'cdemu-daemon-([0-9.]+)\.tar\.xz' | head -n 1)"

      update-source-version cdemu-daemon "$newVersion"
    '';
  };

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
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
    mainProgram = "cdemu-daemon";
  };
})
