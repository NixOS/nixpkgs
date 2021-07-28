{ lib, cmake, ninja, libcprime, libcsys, wrapQtAppsHook }:

let inherit (lib) optional; in

mkDerivation:

args:

let
  args_ = {

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook cmake ninja ];
    buildInputs = (args.buildInputs or []) ++ [ libcprime libcsys ];

  };
in

mkDerivation (args // args_)
