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
          hash = "sha256-l9rYSo2YjaaAQapXJyCp5/qahI5jpwy0IaaCmK35knU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-7reGAFW+EBCizCdN9oimeUqagPL1EUxAzDG8hk4bWTo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-kiRqV6Kb96udRZFFaRM+W11nhU+WFZdiadewKSEY8ts=";
        };
      };
    in
    {
      publisher = "meta";
      name = "pyrefly";
      version = "1.4.0";
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
