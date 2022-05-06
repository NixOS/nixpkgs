{ dotnetPackages, lib, xml2, stdenvNoCC }:

{ name
, description ? ""
, deps ? []
}:

let
  nuget-source = stdenvNoCC.mkDerivation rec {
    inherit name;

    meta.description = description;
    nativeBuildInputs = [ dotnetPackages.Nuget xml2 ];

    buildCommand = ''
      export HOME=$(mktemp -d)
      mkdir -p $out/{lib,share}

      ${lib.concatMapStringsSep "\n" (dep: ''
        nuget init "${dep}" "$out/lib"
      '') deps}

      # Generates a list of all licenses' spdx ids, if available.
      # Note that this currently ignores any license provided in plain text (e.g. "LICENSE.txt")
      find "$out/lib" -name "*.nuspec" -exec sh -c \
        "NUSPEC=\$(xml2 < {}) && echo "\$NUSPEC" | grep license/@type=expression | tr -s \  '\n' | grep "license=" | cut -d'=' -f2" \
      \; | sort -u > $out/share/licenses
    '';
  } // { # We need data from `$out` for `meta`, so we have to use overrides as to not hit infinite recursion.
    meta.licence = let
      depLicenses = lib.splitString "\n" (builtins.readFile "${nuget-source}/share/licenses");
    in (lib.flatten (lib.forEach depLicenses (spdx:
      if (spdx != "")
        then lib.getLicenseFromSpdxId spdx
        else []
    )));
  };
in nuget-source
