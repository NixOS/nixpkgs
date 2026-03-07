{
  lib,
  stdenvNoCC,
}:

/**
  `buildTypstPackage` is a helper builder for Typst packages that can be dependencies for Typst documents.

  # Inputs

    *`typstDeps`* (List of packages)
    : A list of Typst packages that this package depends on

    *`namespace`* (string; _optional_)
    : The Typst namespace the package resides in. Defaults to "preview" as all Typst Universe packages are.

    *`attrs`* (AttrSet; _optional_)
    : All attributes passed to the mkDerivation builder

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
    "namespace"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      # Require that pname, version, and src are passed.
      pname,
      version,
      src,
      typstDeps ? [ ],
      namespace ? "preview",
      ...
    }@attrs:
    {
      __structuredAttrs = true;
      strictDeps = true;

      name = "typst-package-${finalAttrs.pname}-${finalAttrs.version}";

      dontBuild = true;

      installPhase =
        let
          outDir = "$out/lib/typst/packages/${namespace}/${finalAttrs.pname}/${finalAttrs.version}";
        in
        ''
          runHook preInstall
          mkdir -p ${outDir}
          cp -r . ${outDir}
          runHook postInstall
        '';

      propagatedBuildInputs = typstDeps;

      passthru = {
        # If propagatedBuildInputs is overriden, make sure
        # we pass the final ones thru
        inherit (finalAttrs) propagatedBuildInputs;
      };
    };
}
