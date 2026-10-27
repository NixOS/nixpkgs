# Shell-script fragment that packs a Nix store closure into a read-only erofs
# image, built on the host when the VM starts. Shared by the VM backends
# `qemu-vm.nix` and `vz-vm.nix`
{
  hostPkgs,
  # path to a file listing the store paths to pack, one per line
  storePaths,
  # filesystem label of the image
  label,
  # shell word the image is written to
  destination,
}:
''
  ${hostPkgs.gnutar}/bin/tar --create \
    --absolute-names \
    --verbatim-files-from \
    --transform 'flags=rSh;s|/nix/store/||' \
    --transform 'flags=rSh;s|~nix~case~hack~[[:digit:]]\+||g' \
    --files-from ${storePaths} \
    | ${hostPkgs.erofs-utils}/bin/mkfs.erofs \
      --quiet \
      --force-uid=0 \
      --force-gid=0 \
      -L ${label} \
      -U eb176051-bd15-49b7-9e6b-462e0b467019 \
      -T 0 \
      --hard-dereference \
      --tar=f \
      ${destination}
''
