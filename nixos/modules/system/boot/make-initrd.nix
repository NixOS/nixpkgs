let
  # Some metadata on various compression programs, relevant to naming
  # the initramfs file and, if applicable, generating a u-boot image
  # from it.
  compressors = import ../../../../pkgs/build-support/kernel/initrd-compressor-meta.nix;
  # Get the basename of the actual compression program from the whole
  # compression command, for the purpose of guessing the u-boot
  # compression type and filename extension.
  compressorName = fullCommand: builtins.elemAt (builtins.match "([^ ]*/)?([^ ]+).*" fullCommand) 1;
in
{ lib, stdenvNoCC, writeShellScript, findLibs, jq, coreutils, gzip, cpio, findutils, gnugrep, rsync, pkgsBuildHost
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

, contents ? [ ]
}:

stdenvNoCC.mkDerivation {
  name = "initrd";

  __structuredAttrs = true;

  inherit contents extension;
  PATH =
    lib.concatMapStringsSep ":" (p: "${p}/bin") [ findLibs jq coreutils cpio findutils gnugrep rsync ];

  compress = "${_compressorExecutable} ${lib.escapeShellArgs _compressorArgsReal}";
  passthru = {
    compressorExecutableFunction = _compressorFunction;
    compressorArgs = _compressorArgsReal;
  };

  builder = writeShellScript "builder" ''
    set -euo pipefail
    source .attrs.sh
    export out=''${outputs[out]}

    mkdir root

    jq -cMr '.contents[] | [.object, .symlink, .executable][]' < .attrs.json \
    | while read -r obj && read -r sym && read -r exe; do
      test -d "$obj" && obj="$obj/"
      mkdir -p "root/$(dirname "$obj")"
      (set -x; rsync -a "$obj" "root/$obj")

      if [ "$sym" != null ]; then
        mkdir -p "root/$(dirname "$sym")"
        ln -s "$obj" "root/$sym"
      fi

      if [ "$exe" = true ]; then
        find "$obj" -executable -type f | while read -r f; do
          (head -c 4 "$f" | grep ELF > /dev/null) || continue
          (find-libs "$f" || true) | while read -r lib; do
            if [ ! -e "root/$lib" ]; then
              mkdir -p "$(dirname "root/$lib")"
              cp --preserve=all "$lib" "root/$lib"
            fi
          done
        done
      fi
    done

    mkdir "$out"
    (cd root && find * -print0 | sort -z | cpio -o -H newc -R +0:+0 --reproducible --null | eval -- $compress >> $out/initrd)
    ln -s initrd $out/initrd$extension
  '';
}
