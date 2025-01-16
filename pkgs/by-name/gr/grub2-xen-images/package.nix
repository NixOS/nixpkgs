{
  lib,
  stdenv,
  buildPvImage ? false,
  grub2_xen,
  buildPvhImage ? false,
  grub2_xen_pvh,
}:

assert (buildPvImage != buildPvhImage);
let
  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = if buildPvhImage then "i386" else "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

in
(

  stdenv.mkDerivation rec {
    name = "grub2-xen-images";

    configs = ./configs;

    buildInputs = lib.optional buildPvImage grub2_xen ++ lib.optional buildPvhImage grub2_xen_pvh;

    buildCommand =
      let
        grubVariant = if buildPvImage then "xen" else "xen_pvh";
      in
      ''
        cp "${configs}"/* .
        tar -cf memdisk.tar grub.cfg
        # We include all modules except all_video.mod as otherwise grub will fail printing "no symbol table"
        # if we include it.
        grub-mkimage \
          -O "${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-${grubVariant}" \
          -c grub-bootstrap.cfg \
          -m memdisk.tar \
          -o "grub-${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-${grubVariant}.bin" \
          $(ls "${if buildPvImage then grub2_xen else grub2_xen_pvh}/lib/grub/${
            efiSystemsBuild.${stdenv.hostPlatform.system}.target
          }-${grubVariant}/" | grep 'mod''$' | grep -v '^all_video\.mod''$')
        mkdir -p "$out/lib/grub-${grubVariant}"
        cp "grub-${
          efiSystemsBuild.${stdenv.hostPlatform.system}.target
        }-${grubVariant}.bin" $out/lib/grub-${grubVariant}/
      '';

    meta = with lib; {
      description = "PvGrub and PvhGrub images for use for booting PV/PVH Xen guests";

      longDescription = ''
        This package provides PvGrub/PvhGrub images for booting
        Paravirtualized (PV) or Paravirtualized Hardware (PVH) Xen guests
      '';

      platforms = platforms.gnu ++ platforms.linux;
    };
  }
)
