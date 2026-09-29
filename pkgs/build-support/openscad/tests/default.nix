{
  lib,
  stdenv,
  runCommand,
  openscad,
  openscadPackages,
}:

let
  # We may add more libraries as they get added
  dummySrc = runCommand "mock-chaotic-repo" { } ''
    mkdir -p $out/modules \
             $out/unwanted-clutter \
             $out/utils \
             $out/"folder with spaces" \
             $out/empty-dir \
             $out/glob-char-\* \
             $out/dot-files

    echo "module main_core() { sphere(10); }" > $out/core.scad
    echo "module main_utils() { cube(5); }" > $out/utils.scad
    echo "module nested_mod() { cylinder(10); }" > $out/modules/shapes.scad
    echo "module math_helpers() { cube(2); }" > $out/utils/math.scad

    echo "module spaced() { sphere(1); }" > $out/"my file.scad"

    echo "module weird() { echo(\"weird\"); }" > $out/glob-char-\*/actual.scad

    echo "secret config" > $out/modules/.hidden-config

    echo "print('broken script')" > $out/unwanted-clutter/dont_copy_me.py
    echo "unwanted markdown" > $out/README.md
  '';

  openscadPackagesOverridden = openscadPackages.overrideScope (
    openscadFinal: openscadPrev: {
      dummylib = openscadFinal.buildOpenSCADPackage {
        pname = "dummylib";
        version = "1.0.0";
        libName = "dummylib";
        src = dummySrc;
        installTargets = [
          "core.scad"
          "modules"
          "my file.scad"
          "glob-char-*"
          "utils/*.scad"
        ];
      };
    }
  );

  wrappedOpenscad = openscad.override {
    openscadPackages = openscadPackagesOverridden;
  };
in
lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
  withPackages-glob-test =
    runCommand "openscad-withPackages-glob-test"
      {
        nativeBuildInputs = [
          (wrappedOpenscad.withPackages (ps: [ ps.dummylib ]))
        ];
      }
      ''
        openscad -o test.3mf - <<EOF
        use <dummylib/core.scad>
        use <dummylib/modules/shapes.scad>
        use <dummylib/my file.scad>
        use <dummylib/glob-char-*/actual.scad>
        use <dummylib/math.scad>

        main_core();
        nested_mod();
        spaced();
        weird();
        math_helpers();
        EOF
        touch $out
      '';
}
