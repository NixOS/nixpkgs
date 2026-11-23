{
  lib,
  stdenv,
  vscode-utils,
  vscode-extension-update-script,
  pyrefly,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-/YQRGPQ4jOkxq8ITlocdsVkmLyDEwHjLZkj0spfbHOU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-4SC8qXxTFtMPaGBOiFFRM1l7Ysjymu+g2GmAP/DEScc=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-sZLRvvkdQ3X/UQyTJGvNHHXwVgV/PVTXy5uSJ6+uzV8=";
        };
      };
    in
    {
      publisher = "meta";
      name = "pyrefly";
      version = "1.5.0";
    }
    // sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  passthru.updateScript = vscode-extension-update-script { };

  preFixup = ''
    ln -sf ${lib.getExe pyrefly} $out/share/vscode/extensions/meta.pyrefly/bin/pyrefly
  '';

  meta = {
    changelog = "https://github.com/meta/pyrefly/releases/tag/${finalAttrs.version}";
    description = "A fast type checker and language server for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=meta.pyrefly";
    homepage = "https://pyrefly.org/";
    maintainers = with lib.maintainers; [ chvp ];
    license = lib.licenses.mit;
  };
})
