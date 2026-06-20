{
  grub2_pvhgrub_image,
  ...
}@args:

grub2_pvhgrub_image.override (
  {
    grubPlatform = "xen";
  }
  // removeAttrs args [ "grub2_pvhgrub_image" ]
)
