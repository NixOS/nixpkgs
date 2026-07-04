{
  llama-swap,

  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "${llama-swap.pname}-ui";
  inherit (llama-swap) version src;
  npmDepsHash = "sha256-NJqEJ+XTdpPFtJJxP4CGu+JDUW7lKDcFgsixQJ3SXtQ=";

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "../internal/server/ui_dist" "${placeholder "out"}/ui_dist"
  '';

  sourceRoot = "${finalAttrs.src.name}/ui-svelte";

  # bundled "ui_dist" doesn't need node_modules
  postInstall = ''
    rm -rf $out/lib
  '';

  meta = (removeAttrs llama-swap.meta [ "mainProgram" ]) // {
    description = "${llama-swap.meta.description} - UI";
  };
})
