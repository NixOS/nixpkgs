{
  llama-swap,

  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "${llama-swap.pname}-ui";
  inherit (llama-swap) version src;
  npmDepsHash = "sha256-fIDn3vfrqTZfzK8dc+Vpckw9M2iyJi5ggHFEV8PeXtU=";

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
