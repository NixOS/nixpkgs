{ lib, stdenv
, cmake
, libSrc
, stepreduce
, parallel
, zip
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
          zip
        ];

      postInstall = lib.optional (name == "packages3d") ''
        find $out -type f -name '*.step' | parallel 'stepreduce {} {} && zip -9 {.}.stpZ {} && rm {}'
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
