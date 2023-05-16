{ lib, stdenv
, cmake
, gettext
, libSrc
<<<<<<< HEAD
, stepreduce
, parallel
, zip
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
let
  mkLib = name:
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = builtins.substring 0 10 (libSrc name).rev;

      src = libSrc name;

<<<<<<< HEAD
      nativeBuildInputs = [ cmake ]
        ++ lib.optionals (name == "packages3d") [
          stepreduce
          parallel
          zip
        ];

      postInstall = lib.optional (name == "packages3d") ''
        find $out -type f -name '*.step' | parallel 'stepreduce {} {} && zip -9 {.}.stpZ {} && rm {}'
      '';
=======
      nativeBuildInputs = [ cmake ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      meta = rec {
        license = lib.licenses.cc-by-sa-40;
        platforms = lib.platforms.all;
<<<<<<< HEAD
=======
        # the 3d models are a ~1 GiB download and occupy ~5 GiB in store.
        # this would exceed the hydra output limit
        hydraPlatforms = if (name == "packages3d") then [ ] else platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
in
{
  symbols = mkLib "symbols";
  templates = mkLib "templates";
  footprints = mkLib "footprints";
  packages3d = mkLib "packages3d";
}
