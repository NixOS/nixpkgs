{
  lib,
  rustPlatform,
  steel,
}:
rustPlatform.buildRustPackage {
  pname = "steel-language-server";

  inherit (steel)
    version
    src
    cargoHash
    postPatch
    ;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  cargoBuildFlags = [
    "--package"
    "steel-language-server"
  ];

  doCheck = false;

  meta = steel.meta // {
    description = "Steel language server";
    maintainers = steel.meta.maintainers ++ [ lib.maintainers.higherorderlogic ];
    mainProgram = "steel-language-server";
  };
}
