# Create an initramfs containing the closure of the specified
# file system objects.  An initramfs is used during the initial
# stages of booting a Linux system.  It is loaded by the boot loader
# along with the kernel image.  It's supposed to contain everything
# (such as kernel modules) necessary to allow us to mount the root
# file system.  Once the root file system is mounted, the `real' boot
# script can be called.
#
# An initramfs is a cpio archive, and may be compressed with a number
# of algorithms.
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
{
  stdenvNoCC,
  perl,
  cpio,
  ubootTools,
  lib,
  pkgsBuildHost,
  # Name of the derivation (not of the resulting file!)
  name ? "initrd",

  # Program used to compress the cpio archive; use "cat" for no compression.
  # This can also be a function which takes a package set and returns the path to the compressor,
  # such as `pkgs: "${pkgs.lzop}/bin/lzop"`.
  compressor ? "gzip",
  _compressorFunction ?
    if lib.isFunction compressor then
      compressor
    else if !builtins.hasContext compressor && builtins.hasAttr compressor compressors then
      compressors.${compressor}.executable
    else
      _: compressor,
  _compressorExecutable ? _compressorFunction pkgsBuildHost,
  _compressorName ? compressorName _compressorExecutable,
  _compressorMeta ? compressors.${_compressorName} or { },

  # List of arguments to pass to the compressor program, or null to use its defaults
  compressorArgs ? null,
  _compressorArgsReal ?
    if compressorArgs == null then _compressorMeta.defaultArgs or [ ] else compressorArgs,

  # Filename extension to use for the compressed initramfs. This is
  # included for clarity, but $out/initrd will always be a symlink to
  # the final image.
  # If this isn't guessed, you may want to complete the metadata above and send a PR :)
  extension ?
    _compressorMeta.extension
      or (throw "Unrecognised compressor ${_compressorName}, please specify filename extension"),

  # List of { object = path_or_derivation; symlink = "/path"; }
  # The paths are copied into the initramfs in their nix store path
  # form, then linked at the root according to `symlink`.
  contents,

  # List of uncompressed cpio files to prepend to the initramfs. This
  # can be used to add files in specified paths without them becoming
  # symlinks to store paths.
  prepend ? [ ],

  # Whether to wrap the initramfs in a u-boot image.
  makeUInitrd ? stdenvNoCC.hostPlatform.linux-kernel.target == "uImage",

  # If generating a u-boot image, the architecture to use. The default
  # guess may not align with u-boot's nomenclature correctly, so it can
  # be overridden.
  # See https://gitlab.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L81-106 for a list.
  uInitrdArch ? stdenvNoCC.hostPlatform.linuxArch,

  # The name of the compression, as recognised by u-boot.
  # See https://gitlab.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L195-204 for a list.
  # If this isn't guessed, you may want to complete the metadata above and send a PR :)
  uInitrdCompression ?
    _compressorMeta.ubootName
      or (throw "Unrecognised compressor ${_compressorName}, please specify uInitrdCompression"),
}:
let
  # !!! Move this into a public lib function, it is probably useful for others
  toValidStoreName =
    x: with builtins; lib.concatStringsSep "-" (filter (x: !(isList x)) (split "[^a-zA-Z0-9_=.?-]+" x));

in
stdenvNoCC.mkDerivation rec {
  inherit
    name
    makeUInitrd
    extension
    uInitrdArch
    prepend
    ;

  ${if makeUInitrd then "uInitrdCompression" else null} = uInitrdCompression;

  builder = ./make-initrd.sh;

  nativeBuildInputs = [
    perl
    cpio
  ] ++ lib.optional makeUInitrd ubootTools;

  compress = "${_compressorExecutable} ${lib.escapeShellArgs _compressorArgsReal}";

  # Pass the function through, for reuse in append-initrd-secrets. The
  # function is used instead of the string, in order to support
  # cross-compilation (append-initrd-secrets running on a different
  # architecture than what the main initramfs is built on).
  passthru = {
    compressorExecutableFunction = _compressorFunction;
    compressorArgs = _compressorArgsReal;
  };

  # !!! should use XML.
  objects = map (x: x.object) contents;
  symlinks = map (x: x.symlink) contents;
  suffices = map (x: if x ? suffix then x.suffix else "none") contents;

  # For obtaining the closure of `contents'.
  # Note: we don't use closureInfo yet, as that won't build with nix-1.x.
  # See #36268.
  exportReferencesGraph = lib.zipListsWith (x: i: [
    ("closure-${toValidStoreName (baseNameOf x.symlink)}-${toString i}")
    x.object
  ]) contents (lib.range 0 (lib.length contents - 1));
  pathsFromGraph = ./paths-from-graph.pl;
}
