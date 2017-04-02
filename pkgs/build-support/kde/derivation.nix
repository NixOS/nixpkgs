{ stdenv, lib, debug ? false }:

args:

stdenv.mkDerivation (args // {

  outputs = args.outputs or [ "out" "dev" ];

  propagatedUserEnvPkgs =
    builtins.map lib.getBin (args.propagatedBuildInputs or []);

  cmakeFlags =
    (args.cmakeFlags or [])
    ++ [ "-DBUILD_TESTING=OFF" ]
    ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

})
