{ lib, python3, stdenvNoCC }:

{ name
, description ? ""
, deps ? []
}:

let
  nuget-source = stdenvNoCC.mkDerivation rec {
    inherit name;

    meta.description = description;
    nativeBuildInputs = [ python3 ];

    buildCommand = ''
      mkdir -p $out/{lib,share}

      (
        shopt -s nullglob
        for nupkg in ${lib.concatMapStringsSep " " (dep: "\"${dep}\"/*.nupkg") deps}; do
          cp --no-clobber "$nupkg" $out/lib
        done
      )

      # Generates a list of all licenses' spdx ids, if available.
      # Note that this currently ignores any license provided in plain text (e.g. "LICENSE.txt")
      python ${./extract-licenses-from-nupkgs.py} $out/lib > $out/share/licenses
    '';
  } // { # We need data from `$out` for `meta`, so we have to use overrides as to not hit infinite recursion.
    meta.licence = let
      depLicenses = lib.splitString "\n" (builtins.readFile "${nuget-source}/share/licenses");
    in (lib.flatten (lib.forEach depLicenses (spdx:
      lib.optionals (spdx != "") (lib.getLicenseFromSpdxId spdx)
    )));
  };
in nuget-source
