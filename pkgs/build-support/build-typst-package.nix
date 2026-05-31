{
  lib,
  stdenvNoCC,
}:

/**
  `buildTypstPackage` is a helper builder for typst packages.

  # Inputs

    `attrs`
    : attrs for stdenvNoCC.mkDerivation + typstDeps (a list of `buildTypstPackage` derivations)

  # Example
  ```nix
  { buildTypstPackage, typstPackages }:

  buildTypstPackage {
    pname = "example";
    version = "0.0.1";
    src = ./.;
    typstDeps = with typstPackages; [ oxifmt ];
  }
  ```
*/

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "typstDeps"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      typstDeps ? [ ],
      ...
    }@attrs:
    {
      name = "typst-package-${finalAttrs.pname}-${finalAttrs.version}";

      dontBuild = true;

      installPhase =
        let
          outDir = "$out/lib/typst-packages/${finalAttrs.pname}/${finalAttrs.version}";
        in
        ''
          runHook preInstall
          mkdir -p ${outDir}
          cp -r . ${outDir}
          runHook postInstall
        '';

      propagatedBuildInputs = typstDeps;

      passthru = {
        inherit typstDeps;
      };
    };
}
