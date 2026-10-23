{
  lib,
  makeWrapper,
  symlinkJoin,
  buildEnv,
  openscad,
  openscadPackages,
}:

f:

assert lib.assertMsg (lib.isFunction f)
  "openscad.withPackages: Expected `f` to be callable (e.g., 'ps: [ ps.bosl2 ]'), but received a ${lib.typeOf f}.";

let
  selectedPackages = f openscadPackages;
in

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
