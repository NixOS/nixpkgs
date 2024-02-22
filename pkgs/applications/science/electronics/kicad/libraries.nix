{ lib, stdenv
, cmake
, gettext
, libSrc
, stepreduce
, parallel
, gzip
}:
let
  mkLib = name:
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = builtins.substring 0 10 (libSrc name).rev;

      src = libSrc name;

      nativeBuildInputs = [ cmake ]
        ++ lib.optionals (name == "packages3d") [
          stepreduce
          parallel
          gzip
        ];

      # stepreduce and gzip the .step files (required to make packages3d fit on hydra)
      # exclude the 1 step file that is directly referenced by a footprint (on 2024-02-14)
      # can't compress the .wrl files because the footprints references include the extension
      # .stpZ only works because KiCad implicitly looks for a step file when doing a step export
      # and apparently can handle the .stpZ extension and compression in that export

      # and stepreduce that one step file (can't gzip this as the footprint doesn't refer to .stpZ)

      postInstall = lib.optional (name == "packages3d") ''
        find $out -type f -name '*.step' -not -name 'EasterEgg_EWG1308-2013_ClassA.step' \
        | parallel 'stepreduce {} {} && gzip -c9 {} > {.}.stpZ && rm {}'

        find $out -type f -name 'EasterEgg_EWG1308-2013_ClassA.step' -exec stepreduce {} {} \;
      '';

      meta = rec {
        license = lib.licenses.cc-by-sa-40;
        platforms = lib.platforms.all;
      };
    };
in
{
  symbols = mkLib "symbols";
  templates = mkLib "templates";
  footprints = mkLib "footprints";
  packages3d = mkLib "packages3d";
}
