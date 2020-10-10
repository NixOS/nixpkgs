{ stdenv
, cmake
, gettext
, libSrc
, libVersion
}:
let
  mkLib = name:
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = libVersion;

      src = libSrc name;

      nativeBuildInputs = [ cmake ];

      meta = rec {
        license = stdenv.lib.licenses.cc-by-sa-40;
        platforms = stdenv.lib.platforms.all;
        # the 3d models are a ~1 GiB download and occupy ~5 GiB in store.
        # this would exceed the hydra output limit
        hydraPlatforms = if (name == "packages3d") then [ ] else platforms;
      };
    };
in
{
  symbols = mkLib "symbols";
  templates = mkLib "templates";
  footprints = mkLib "footprints";
  packages3d = mkLib "packages3d";
}
