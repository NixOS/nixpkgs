{
  lib,
  stdenv,
  cmake,
  libSrc,
  stepreduce,
  parallel,
  zip,
}:
let
  mkLib =
    name:
    stdenv.mkDerivation rec {
      pname = "kicad-${name}";
      version = builtins.substring 0 10 (libSrc name).rev;

      src = libSrc name;

      nativeBuildInputs =
        [ cmake ]
        ++ lib.optionals (name == "packages3d") [
          stepreduce
          parallel
          zip
        ];

      passthru.postInstallScripts = {
        footprints = ''
          FOOTPRINT_DIR=$out/share/kicad/footprints
          if [ -d $FOOTPRINT_DIR ]; then
            find $FOOTPRINT_DIR -type f -name '*.kicad_mod' -exec sed -i 's/\.step/\.stpZ/g' {} \;
          fi
        '';

        packages3d = ''
          find $out -type f -name '*.step' | parallel 'stepreduce {} {} && zip -9 {.}.stpZ {} && rm {}'
        '';
      };

      postInstall = passthru.postInstallScripts.${name} or "";

      meta = {
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
