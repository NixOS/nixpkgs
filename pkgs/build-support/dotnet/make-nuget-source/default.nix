{ dotnetPackages, lib, xml2, stdenvNoCC }:
{ name, description ? "", deps ? [] }:
let
  _nuget-source = stdenvNoCC.mkDerivation rec {
    inherit name;
    meta.description = description;

    nativeBuildInputs = [ dotnetPackages.Nuget xml2 ];
    buildCommand = ''
      export HOME=$(mktemp -d)
      mkdir -p $out/{lib,share}

      nuget sources Add -Name nixos -Source "$out/lib"
      ${ lib.concatMapStringsSep "\n" (dep:
          ''nuget init "${dep}" "$out/lib"''
        ) deps }

      # Generates a list of all unique licenses' spdx ids.
      find "$out/lib" -name "*.nuspec" -exec sh -c \
        "xml2 < {} | grep "license=" | cut -d'=' -f2" \; | sort -u > $out/share/licenses
    '';
} // { # This is done because we need data from `$out` for `meta`. We have to use overrides as to not hit infinite recursion.
  meta.licence = let
    depLicenses = lib.splitString "\n" (builtins.readFile "${_nuget-source}/share/licenses");
    getLicence = spdx: lib.filter (license: license.spdxId or null == spdx) (builtins.attrValues lib.licenses);
  in (lib.flatten (lib.forEach depLicenses (spdx:
    if (getLicence spdx) != [] then (getLicence spdx) else [] ++ lib.optional (spdx != "") spdx
  )));
};
in _nuget-source
