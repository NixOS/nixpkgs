{
  lib,
  stdenvNoCC,
  yq-go,
}:

/**
  `buildTypstPackage` is a help builder for typst packages.

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
  nativeBuildInputs ? [ ],
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

    nativeBuildInputs = nativeBuildInputs ++ lib.singleton yq-go;

    installPhase =
      let
        outDir = "$out/lib/${attrs.pname}/${attrs.version}";
      in
      ''
        runHook preInstall
        mkdir -p ${outDir}

        for excluded in $(yq '.package.exclude[]' typst.toml)
        do
          rm -r $excluded
        done

        cp -r . ${outDir}
        runHook postInstall
      '';

    passthru = {
      inherit typstDeps;
    };
  }
)
