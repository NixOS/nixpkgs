{
  lib,
  stdenvNoCC,
  idris2-src,
  idris2-version,
  idris2-unwrapped,
}:
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "dependencies"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      name,
      dependencies ? [ ],
    }:
    {
      pname = name;
      version = idris2-version;
      src = idris2-src;
      strictDeps = true;

      makeFlags = "IDRIS2=${lib.getExe idris2-unwrapped}";

      enableParallelBuilding = true;
      preBuild = ''
        cd libs/${name}
      '';

      env = {
        IDRIS2_PREFIX = placeholder "out";
        IDRIS2_PACKAGE_PATH = lib.makeSearchPath "idris2-${idris2-version}" dependencies;
      };
    };
}
