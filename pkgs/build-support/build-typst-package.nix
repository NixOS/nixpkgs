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

{
  typstDeps ? [ ],
  ...
}@attrs:
let
  cleanAttrs = lib.flip lib.removeAttrs [ "typstDeps" ];
in
stdenvNoCC.mkDerivation (
  (cleanAttrs attrs)
  // {
    name = "typst-package-${attrs.pname}-${attrs.version}";

    installPhase =
      let
        outDir = "$out/lib/typst-packages/${attrs.pname}/${attrs.version}";
      in
      ''
        runHook preInstall
        mkdir -p ${outDir}
        cp -r . ${outDir}
        runHook postInstall
      '';

    passthru = {
      inherit typstDeps;
    };
  }
)
