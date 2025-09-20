{
  lib,
  callPackage,
  pkg-config,
  stdenv,
  kernel,
}@topLevelArgs:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      nativeBuildInputs ? [ ],
      kernel ? topLevelArgs.kernel,
      hardeningDisable ? [ ],
      enableParallelBuilding ? true,
      ...
    }@args:

    {
      name = "${pname}-${kernel.version}-${version}";
      nativeBuildInputs = nativeBuildInputs ++ kernel.moduleBuildDependencies;

      hardeningDisable = hardeningDisable ++ [ "pic" ];
      inherit enableParallelBuilding;

      meta = args.meta // {
        platforms = args.meta.platforms or lib.platforms.linux;
      };
    };
}
