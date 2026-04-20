{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vhba";
  version = "20250329";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${finalAttrs.version}.tar.xz";
    hash = "sha256-piog1yDd8M/lpTIo9FE9SY2JwurZ6a8LG2lZ/4EmB14=";
  };

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  passthru = {
    updateScript = writeScript "update-vhba-module" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Fetch the latest version from the SourceForge RSS feed for vhba-module
      newVersion="$(curl -s "https://sourceforge.net/projects/cdemu/rss?path=/vhba-module" | pcre2grep -o1 'vhba-module-([0-9.]+)\.tar\.xz' | head -n 1)"

      update-source-version linuxPackages.vhba "$newVersion"
    '';
  };

  meta = {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "https://cdemu.sourceforge.io/about/vhba/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bendlas ];
  };
})
