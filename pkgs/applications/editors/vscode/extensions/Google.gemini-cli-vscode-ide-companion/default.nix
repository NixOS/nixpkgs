{
  lib,
  vscode-utils,
  gemini-cli,
  vsce,
}:
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "gemini-cli-vscode-ide-companion";
  inherit (gemini-cli) version;

  vscodeExtPublisher = "Google";
  vscodeExtName = "gemini-cli-vscode-ide-companion";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = gemini-cli.overrideAttrs (oldAttrs: {
    pname = "gemini-cli-vscode-ide-companion-vsix";

    nativeBuildInputs = gemini-cli.nativeBuildInputs ++ [ vsce ];

    installPhase = ''
      runHook preInstall

      npm --workspace=gemini-cli-vscode-ide-companion run package -- --out $out

      runHook postInstall
    '';
  });

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  meta = {
    description = "Enable Gemini CLI with direct access to your IDE workspace";
    homepage = "https://github.com/google-gemini/gemini-cli";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.gemini-cli-vscode-ide-companion";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
