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
  targets = {
    i686-linux.target = "i386";
    x86_64-linux.target = if grubPlatform == "xen_pvh" then "i386" else "x86_64";
  };
in
stdenv.mkDerivation {
  name = "grub2_${grubPlatform}_image";

  env = {
    GRUB_CONFIGS = "${./configs}";
    GRUB_FORMAT = "${targets.${stdenv.buildPlatform.system}.target}-${grubPlatform}";
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
    description = "PvGrub2 image for booting ${
      if grubPlatform == "xen_pvh" then "PVH" else "PV"
    } Xen guests";

    longDescription =
      if (grubPlatform == "xen_pvh") then
        ''
          This package provides a prebuilt PvGrub2 image for booting PVH Xen
          guests (also commonly referred to as PvhGrub2), which searches for
          `grub.cfg` on the guest disk and interprets it to load the kernel,
          eliminating the need to copy the guest kernel to the Dom0.

          You will need `pkgs.grub2_xen_pvh` to build a customized PvhGrub2
          image. See [PvGrub2](https://wiki.xenproject.org/wiki/PvGrub2) for
          more explanations.
        ''
      else
        ''
          This package provides a prebuilt PvGrub2 image for booting PV Xen
          guests, which searches for `grub.cfg` on the guest disk and interprets
          it to load the kernel, eliminating the need to copy the guest kernel
          to the Dom0.

          You will need `pkgs.grub2_xen` to build a customized PvGrub2 image.
          See [PvGrub2](https://wiki.xenproject.org/wiki/PvGrub2) for more
          explanations.
        '';

    teams = [ lib.teams.xen ];
    platforms = lib.attrNames targets;
  };
}
