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
{ stdenvNoCC, perl, cpio, ubootTools, lib, pkgsBuildHost, makeInitrdNGTool, patchelf, runCommand
# Name of the derivation (not of the resulting file!)
, name ? "initrd"

# Program used to compress the cpio archive; use "cat" for no compression.
# This can also be a function which takes a package set and returns the path to the compressor,
# such as `pkgs: "${pkgs.lzop}/bin/lzop"`.
, compressor ? "gzip"
, _compressorFunction ?
  if lib.isFunction compressor then compressor
  else if ! builtins.hasContext compressor && builtins.hasAttr compressor compressors then compressors.${compressor}.executable
  else _: compressor
, _compressorExecutable ? _compressorFunction pkgsBuildHost
, _compressorName ? compressorName _compressorExecutable
, _compressorMeta ? compressors.${_compressorName} or {}

# List of arguments to pass to the compressor program, or null to use its defaults
, compressorArgs ? null
, _compressorArgsReal ? if compressorArgs == null then _compressorMeta.defaultArgs or [] else compressorArgs

# Filename extension to use for the compressed initramfs. This is
# included for clarity, but $out/initrd will always be a symlink to
# the final image.
# If this isn't guessed, you may want to complete the metadata above and send a PR :)
, extension ? _compressorMeta.extension or
    (throw "Unrecognised compressor ${_compressorName}, please specify filename extension")

# List of { object = path_or_derivation; symlink = "/path"; }
# The paths are copied into the initramfs in their nix store path
# form, then linked at the root according to `symlink`.
, contents

# List of uncompressed cpio files to prepend to the initramfs. This
# can be used to add files in specified paths without them becoming
# symlinks to store paths.
, prepend ? []
}: runCommand name {
  compress = "${_compressorExecutable} ${lib.escapeShellArgs _compressorArgsReal}";
  passthru = {
    compressorExecutableFunction = _compressorFunction;
    compressorArgs = _compressorArgsReal;
  };

  passAsFile = ["contents"];
  contents = lib.concatMapStringsSep "\n" ({ object, symlink, ... }: "${object}\n${if symlink == null then "" else symlink}") contents + "\n";

  nativeBuildInputs = [makeInitrdNGTool patchelf cpio];
} ''
  mkdir ./root
  make-initrd-ng "$contentsPath" ./root
  mkdir "$out"
  (cd root && find * .[^.*] -exec touch -h -d '@1' '{}' +)
  for PREP in $prepend; do
    cat $PREP >> $out/initrd
  done
  (cd root && find * .[^.*] -print0 | sort -z | cpio -o -H newc -R +0:+0 --reproducible --null | eval -- $compress >> "$out/initrd")

  ln -s "initrd" "$out/initrd$extension"
''
