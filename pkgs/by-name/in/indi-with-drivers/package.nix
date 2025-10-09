{
  lib,
  buildEnv,
  makeBinaryWrapper,
  indilib ? indilib,
  pname ? "indi-with-drivers",
  version ? indilib.version,
  extraDrivers ? [ ],
}:

buildEnv {
  name = "${pname}-${version}";

  paths = [ indilib ] ++ extraDrivers;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = lib.optionalString (extraDrivers != [ ]) ''
    rm $out/bin/indiserver
    makeBinaryWrapper ${indilib}/bin/indiserver $out/bin/indiserver --set-default INDIPREFIX $out
  '';

  inherit (indilib) meta;
}
