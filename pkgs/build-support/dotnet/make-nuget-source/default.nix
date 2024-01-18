{ lib, python3, stdenvNoCC }:

{ name
, description ? ""
, deps ? []
, ...
}@args:

stdenvNoCC.mkDerivation (lib.recursiveUpdate {
  inherit name;

  nativeBuildInputs = [ python3 ];

  buildCommand = ''
    mkdir -p $out/{lib,share}

    # use -L to follow symbolic links. When `projectReferences` is used in
    # buildDotnetModule, one of the deps will be a symlink farm.
    find -L ${lib.concatStringsSep " " deps} -type f -name '*.nupkg' -exec \
      ln -s '{}' -t $out/lib ';'

    # Generates a list of all licenses' spdx ids, if available.
    # Note that this currently ignores any license provided in plain text (e.g. "LICENSE.txt")
    python ${./extract-licenses-from-nupkgs.py} $out/lib > $out/share/licenses
  '';

  meta.description = description;
} (removeAttrs args [ "name" "description" "deps" ]))
