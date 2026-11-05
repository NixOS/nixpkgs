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
  compression ? null,
  kernelConfig ? null,
}:
let
  inherit (hostPkgs) lib;
  kernelOptions = {
    lz4 = "EROFS_FS_ZIP";
    lz4hc = "EROFS_FS_ZIP";
    lzma = "EROFS_FS_ZIP_LZMA";
    deflate = "EROFS_FS_ZIP_DEFLATE";
    libdeflate = "EROFS_FS_ZIP_DEFLATE";
    zstd = "EROFS_FS_ZIP_ZSTD";
  };
  compressor = if builtins.isString compression then { ${compression} = { }; } else compression;
  algorithm = lib.head (lib.attrNames compressor);
  settings = lib.filterAttrs (_: value: value != null) compressor.${algorithm};
  compressionArgument = lib.concatStringsSep "," (
    [ algorithm ]
    ++ lib.mapAttrsToList (
      name: value: "${if name == "dictionarySize" then "dictsize" else name}=${toString value}"
    ) settings
  );
in
lib.optionalString (compression != null && kernelConfig != null) ''
  if ! ${hostPkgs.gnugrep}/bin/grep -qx 'CONFIG_${kernelOptions.${algorithm}}=y' ${lib.escapeShellArg (toString kernelConfig)}; then
    echo 'virtualisation.nixStoreImageCompression: ${algorithm} requires CONFIG_${kernelOptions.${algorithm}}=y in the guest kernel.' >&2
    exit 1
  fi
''
+ ''
  ${hostPkgs.gnutar}/bin/tar --create \
    --absolute-names \
    --verbatim-files-from \
    --transform 'flags=rSh;s|/nix/store/||' \
    --transform 'flags=rSh;s|~nix~case~hack~[[:digit:]]\+||g' \
    --files-from ${storePaths} \
    | ${hostPkgs.erofs-utils}/bin/mkfs.erofs \
      --quiet \
      ${lib.optionalString (compression != null) "-z ${lib.escapeShellArg compressionArgument}"} \
      --force-uid=0 \
      --force-gid=0 \
      -L ${label} \
      -U eb176051-bd15-49b7-9e6b-462e0b467019 \
      -T 0 \
      --hard-dereference \
      --tar=f \
      ${destination}
''
