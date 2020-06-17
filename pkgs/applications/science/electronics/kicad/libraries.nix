{ lib, stdenv, cmake, gettext
, fetchFromGitHub, fetchFromGitLab
, version, libSources
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
  mkLib = name:
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = "${version}";
      src = fetchFromGitHub (
        {
          owner = "KiCad";
          repo = "kicad-${name}";
          rev = version;
          inherit name;
        } // (libSources.${name} or { })
      );
      nativeBuildInputs = [ cmake ];

      meta = rec {
        license = licenses.cc-by-sa-40;
        platforms = stdenv.lib.platforms.all;
        # the 3d models are a ~1 GiB download and occupy ~5 GiB in store.
        # this would exceed the hydra output limit
        hydraPlatforms = if (name == "packages3d" ) then [ ] else platforms;
      };
    };
in
{
  symbols = mkLib "symbols";
  templates = mkLib "templates";
  footprints = mkLib "footprints";
  packages3d = mkLib "packages3d";

  # i18n is a special case, not actually a library
  # more a part of kicad proper, but also optional and separate
  # since their move to gitlab they're keeping it in a separate path
  # kicad has no way to find i18n except through a path relative to its install path
  # therefore this is being linked into ${kicad-base}/share/
  # and defined here to make use of the rev & sha256's brought here for the libs
  i18n = let name = "i18n"; in
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = "${version}";
      src = fetchFromGitLab (
        {
          group = "kicad";
          owner = "code";
          repo = "kicad-${name}";
          rev = version;
          inherit name;
        } // (libSources.${name} or { })
      );
      buildInputs = [ gettext ];
      nativeBuildInputs = [ cmake ];
      meta = {
        license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
        platforms = stdenv.lib.platforms.all;
      };
    };
}
