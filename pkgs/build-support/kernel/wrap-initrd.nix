# This derivation wraps 'rawInitialRamdisk' in a U-Boot image, if it has
# detected that it is desirable, by checking if the kernel image is an 'uImage'

let
  # Some metadata on various compression programs, relevant to naming
  # the initramfs file and, if applicable, generating a u-boot image
  # from it.
  compressors = import ./initrd-compressor-meta.nix;

  # Get the basename of the actual compression program from the whole
  # compression command, for the purpose of guessing the u-boot
  # compression type and filename extension.
  compressorName = fullCommand: builtins.elemAt (builtins.match "([^ ]*/)?([^ ]+).*" fullCommand) 1;
in
{ stdenvNoCC
, lib
, pkgsBuildHost
, runCommand
, ubootTools
, rawInitialRamdisk

  # Program used to compress the cpio archive; use "cat" for no compression.
  # This can also be a function which takes a package set and returns the path to the compressor,
  # such as `pkgs: "${pkgs.lzop}/bin/lzop"`.
, compressor ? "gzip"
, _compressorFunction ? if lib.isFunction compressor then compressor
  else if ! builtins.hasContext compressor && builtins.hasAttr compressor compressors then compressors.${compressor}.executable
  else _: compressor
, _compressorExecutable ? _compressorFunction pkgsBuildHost
, _compressorName ? compressorName _compressorExecutable
, _compressorMeta ? compressors.${_compressorName} or { }

  # If generating a u-boot image, the architecture to use. The default
  # guess may not align with u-boot's nomenclature correctly, so it can
  # be overridden.
  # See https://gitlab.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L81-106 for a list.
, uInitrdArch ? stdenvNoCC.hostPlatform.linuxArch

  # The name of the compression, as recognised by u-boot.
  # See https://gitlab.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L195-204 for a list.
  # If this isn't guessed, you may want to complete the metadata above and send a PR :)
, uInitrdCompression ? _compressorMeta.ubootName or
    (throw "Unrecognised compressor ${_compressorName}, please specify uInitrdCompression")
}:

if stdenvNoCC.hostPlatform.linux-kernel.target == "uImage"
then
  runCommand "uboot-${rawInitialRamdisk.name}"
  {
    nativeBuildInputs = [ ubootTools ];
    inherit uInitrdArch uInitrdCompression;
  } ''
    mkdir -p $out
    mkimage -A "$uInitrdArch" -O linux -T ramdisk -C "$uInitrdCompression" -d "${rawInitialRamdisk}/initrd" $out/initrd.img
    # Compatibility symlink
    ln -sf "initrd.img" "$out/initrd"
  ''
else
  # No-op
  rawInitialRamdisk
