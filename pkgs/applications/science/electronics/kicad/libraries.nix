{ lib, stdenv, fetchFromGitHub, cmake, gettext
, version
, libSources
}:

# callPackage libraries {
#   version = "unstable";
#   libs.symbols = {
#     rev = "09f9..";
#     sha256 = "...";
#   };
# };
with lib;
let
  mkLib = name: attrs:
    stdenv.mkDerivation ({
      name = "kicad-${name}-${version}";
      src = fetchFromGitHub ({
        owner = "KiCad";
        repo = "kicad-${name}";
        rev = version;
        inherit name;
      } // (libSources.${name} or {}));
      nativeBuildInputs = [ cmake ];
    } // attrs);
in
{
  symbols = mkLib "symbols" {
    meta.license = licenses.cc-by-sa-40;
  };
  templates = mkLib "templates" {
    meta.license = licenses.cc-by-sa-40;
  };
  footprints = mkLib "footprints" {
    meta.license = licenses.cc-by-sa-40;
  };
  i18n = mkLib "i18n" {
    buildInputs = [ gettext ];
    meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
  };
  packages3d = mkLib "packages3d" {
    hydraPlatforms = []; # this is a ~1 GiB download, occupies ~5 GiB in store
    meta.license = licenses.cc-by-sa-40;
  };
}
