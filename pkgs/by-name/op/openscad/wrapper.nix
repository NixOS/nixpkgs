{
  lib,
  makeWrapper,
  symlinkJoin,
  buildEnv,
  openscad,
  openscadPackages,
}:

f:

assert lib.assertMsg (builtins.isFunction f)
  "openscad.withPackages: Expected a function (e.g., 'ps: [ ps.bosl2 ]'), but received a ${builtins.typeOf f}.";

let
  selectedPackages = f openscadPackages;

  validOutputs = map (p: p.outPath or "") (builtins.attrValues openscadPackages);

  invalidPackages = builtins.filter (
    pkg: !(builtins.elem (pkg.outPath or "") validOutputs)
  ) selectedPackages;

in
assert lib.assertMsg (builtins.length invalidPackages == 0)
  "openscad.withPackages: One or more packages were not selected from the provided package set (did you forget the .ps prefix?).";

symlinkJoin {
  name = "${openscad.pname}-with-packages-${openscad.version}";
  paths = [ openscad ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    rm $out/bin/openscad

    # Add the OPENSCADPATH environment variable
    makeWrapper ${openscad}/bin/openscad $out/bin/openscad \
      --set OPENSCADPATH ${lib.makeSearchPath "share/openscad/libraries" selectedPackages}
  '';

  passthru = {
    unwrapped = openscad;
    withPackages = openscad.withPackages;
  };
}
