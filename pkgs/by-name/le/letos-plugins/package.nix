{
  stdenv,
  lib,
  python3,
  tcl,

  letos,
}:

stdenv.mkDerivation {
  pname = "letos-plugins";

  inherit (letos)
    version
    src
    nativeBuildInputs
    ;

  buildInputs = letos.buildInputs ++ [
    python3
    tcl
  ];

  __structuredAttrs = true;
  strictDeps = true;

  cmakeDir = "../Plugins";

  cmakeFlags = [
    (lib.cmakeBool "WITH_ALL_PLUGINS" true)
    (lib.cmakeBool "WITH_DYNAMIC_PYTHON" true)
  ];

  meta = builtins.removeAttrs letos.meta [ "mainProgram" ] // {
    description = "Official plugins for Letos (formerly SQLiteStudio)";
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
  };
}
