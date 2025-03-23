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
  cpio,
  ubootTools,
  lib,
  pkgsBuildHost,
  makeInitrdNGTool,
  binutils,
  runCommand,
  # Name of the derivation (not of the resulting file!)
  name ? "initrd",

  strip ? true,

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

  # List of { source = path_or_derivation; target = "/path"; }
  # The paths are copied into the initramfs in their nix store path
  # form, then linked at the root according to `target`.
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
  uInitrdArch ? stdenvNoCC.hostPlatform.ubootArch,

  # The name of the compression, as recognised by u-boot.
  # See https://gitlab.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L195-204 for a list.
  # If this isn't guessed, you may want to complete the metadata above and send a PR :)
  uInitrdCompression ?
    _compressorMeta.ubootName
      or (throw "Unrecognised compressor ${_compressorName}, please specify uInitrdCompression"),
}:
runCommand name
  ({
    compress = "${_compressorExecutable} ${lib.escapeShellArgs _compressorArgsReal}";
    passthru = {
      compressorExecutableFunction = _compressorFunction;
      compressorArgs = _compressorArgsReal;
    };

    inherit
      extension
      makeUInitrd
      uInitrdArch
      prepend
      ;
    ${if makeUInitrd then "uInitrdCompression" else null} = uInitrdCompression;

    passAsFile = [ "contents" ];
    contents = builtins.toJSON contents;

    nativeBuildInputs =
      [
        makeInitrdNGTool
        cpio
      ]
      ++ lib.optional makeUInitrd ubootTools
      ++ lib.optional strip binutils;

    STRIP = if strip then "${pkgsBuildHost.binutils.targetPrefix}strip" else null;
  })
  ''
    mkdir -p ./root/var/empty
    make-initrd-ng "$contentsPath" ./root
    mkdir "$out"
    (cd root && find . -exec touch -h -d '@1' '{}' +)
    for PREP in $prepend; do
      cat $PREP >> $out/initrd
    done
    (cd root && find . -print0 | sort -z | cpio --quiet -o -H newc -R +0:+0 --reproducible --null | eval -- $compress >> "$out/initrd")

    if [ -n "$makeUInitrd" ]; then
        mkimage -A "$uInitrdArch" -O linux -T ramdisk -C "$uInitrdCompression" -d "$out/initrd" $out/initrd.img
        # Compatibility symlink
        ln -sf "initrd.img" "$out/initrd"
    else
        ln -s "initrd" "$out/initrd$extension"
    fi
  ''
