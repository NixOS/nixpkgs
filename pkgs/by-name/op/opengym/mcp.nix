{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs_26,
  version,
  src,
}:
buildNpmPackage (finalAttrs: {
  pname = "opengym-mcp";
  inherit version;

  __structuredAttrs = true;

  src = src;

  sourceRoot = "${finalAttrs.src.name}/mcp";

  npmDepsHash = "sha256-CjJiFKjBfXQMzi4qBnALV9mqG3G4GnUJLImWev6qiWA=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/lib/opengym-mcp $out/bin
    cp -r . $out/lib/opengym-mcp/

    makeWrapper ${nodejs_26}/bin/node $out/bin/opengym-mcp \
      --add-flags "$out/lib/opengym-mcp/src/index.js" \
      --set NODE_ENV production
  '';

  meta = {
    description = "openGym MCP server — read-only stdio bridge for LLM clients";
    homepage = "https://gitlab.com/DuarteSantos8/opengym";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = lib.platforms.linux;
  };
})
