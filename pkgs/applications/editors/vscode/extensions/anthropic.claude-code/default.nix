{
  lib,
  vscode-utils,
  claude-code,
}:
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "claude-code";
  inherit (claude-code) version;

  vscodeExtPublisher = "anthropic";
  vscodeExtName = "claude-code";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = "${claude-code}/lib/node_modules/@anthropic-ai/claude-code/vendor/claude-code.vsix";

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
