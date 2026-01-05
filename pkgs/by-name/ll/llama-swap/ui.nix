{
  llama-swap,

  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "${llama-swap.pname}-ui";
  inherit (llama-swap) version src;
  npmDepsHash = "sha256-RKPcMwJ0qVOgbTxoGryrLn7AW0Bfmv9WasoY+gw4B30=";

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "../proxy/ui_dist" "${placeholder "out"}/ui_dist"
  '';

  sourceRoot = "${finalAttrs.src.name}/ui";

  # bundled "ui_dist" doesn't need node_modules
  postInstall = ''
    rm -rf $out/lib
  '';

  meta = (removeAttrs llama-swap.meta [ "mainProgram" ]) // {
    description = "${llama-swap.meta.description} - UI";
  };
})
