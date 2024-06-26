{
  lib,
  stdenv,
  spigot,
}:

stdenv.mkDerivation {
  pname = "spigot-approximation";
  inherit (spigot) version;

  nativeBuildInputs = [ spigot ];

  dontInstall = true;

  buildCommand = ''
    [ "$(spigot -b2 -d32 '(pi/1-355/113)')" = "-0.00000000000000000000010001111001" ]
    [ "$(spigot -b2 -d32 '(e/1-1457/536)')" = "-0.00000000000000000001110101101011" ]
    touch $out
  '';

  meta.timeout = 10;
}
