{
  lib,
  rustPlatform,
  makeBinaryWrapper,
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

  nativeBuildInputs = [
    makeBinaryWrapper
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [
    "--package"
    "steel-language-server"
  ];

  doCheck = false;

  postFixup = ''
    wrapProgram "$out/bin/steel-language-server" --prefix STEEL_SEARCH_PATHS : "${steel}/lib/steel/cogs"
  '';

  meta = steel.meta // {
    description = "Steel language server";
    maintainers = steel.meta.maintainers ++ [ lib.maintainers.higherorderlogic ];
    mainProgram = "steel-language-server";
  };
}
