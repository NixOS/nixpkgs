{
  lib,
  stdenv,
  grub2_xen,
  grub2_xen_pvh,
  grubPlatform ? "xen_pvh",
}:

assert lib.assertOneOf "grubPlatform" grubPlatform [
  "xen"
  "xen_pvh"
];
let
  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = if grubPlatform == "xen_pvh" then "i386" else "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };
in
stdenv.mkDerivation {
  name = "grub2_xen_images";

  env = {
    GRUB_CONFIGS = "${./configs}";
    GRUB_FORMAT = "${efiSystemsBuild.${stdenv.buildPlatform.system}.target}-${grubPlatform}";
  };

  buildInputs =
    lib.optional (grubPlatform == "xen") grub2_xen
    ++ lib.optional (grubPlatform == "xen_pvh") grub2_xen_pvh;

  dontUnpack = true;

  buildPhase = ''
    cp "$GRUB_CONFIGS"/* .
    tar -cf memdisk.tar grub.cfg
    grub-mkimage \
      -O "$GRUB_FORMAT" \
      -c grub-bootstrap.cfg \
      -m memdisk.tar \
      -o grub-"$GRUB_FORMAT".bin \
      ${if grubPlatform == "xen_pvh" then grub2_xen_pvh else grub2_xen}/lib/grub/"$GRUB_FORMAT"/*.mod
  '';

  installPhase = ''
    mkdir -p "$out/lib/grub-${grubPlatform}"
    cp grub-"$GRUB_FORMAT".bin $out/lib/grub-${grubPlatform}/
  '';

  dontFixup = true;

  meta = {
    description = "GRUB2 (PvGrub2) images for booting PV/PVH Xen guests";

    longDescription = ''
      This package provides prebuilt PvGrub2 images for booting PV and PVH
      (commonly referred to as PvhGrub2 in this case) Xen guests, which search
      for `grub.cfg` on the guest disk and interpret it to load the kernel,
      eliminating the need to copy the guest kernel to the Dom0.

      - To boot a PV guest, use `pkgs.grub2_pvgrub_image`
      - To boot a PVH guest, use `pkgs.grub2_pvhgrub_image`. Please note that
        the `i386` image is used for booting both 32-bit and 64-bit guests.

      You will need `pkgs.grub2_xen` or `pkgs.grub2_xen_pvh` to build a
      customized PvGrub2/PvhGrub2 image. See
      [PvGrub2](https://wiki.xenproject.org/wiki/PvGrub2) for more explanations.
    '';

    maintainers = lib.teams.xen.members;
    platforms = lib.platforms.linux;
  };
}
