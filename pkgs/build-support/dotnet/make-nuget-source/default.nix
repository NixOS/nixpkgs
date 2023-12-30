{ lib, python3, stdenvNoCC }:

{ name
, description ? ""
, deps ? []
}:

stdenvNoCC.mkDerivation (finalAttrs: {
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

  meta = {
    inherit description;
    licenses = let
      # TODO: avoid IFD
      depLicenses = lib.splitString "\n" (builtins.readFile "${finalAttrs.finalPackage}/share/licenses");
      in lib.flatten (lib.forEach depLicenses (spdx:
        lib.optionals (spdx != "") (lib.getLicenseFromSpdxId spdx)
      ));
  };
})
