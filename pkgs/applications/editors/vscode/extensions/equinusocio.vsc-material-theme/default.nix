{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsc-material-theme";
    publisher = "Equinusocio";
    version = "34.3.1";
    hash = "sha256-3yxFTMtjJR1b4EzBDfm55HF9chrya5OUF5wN+KHEduE=";
  };

  # extensions wants to write at the /nix/store path, so we patch it to use the globalStorageUri instead.
  prePatch = ''
    substituteInPlace ./build/core/extension-manager.js \
      --replace-fail "path_1.posix.join(extensionFolderUri.path, env_1.USER_CONFIG_FILE_NAME)" "path_1.posix.join(ExtensionContext.globalStorageUri.fsPath, env_1.USER_CONFIG_FILE_NAME)"
  '';

  meta = with lib; {
    changelog = "https://marketplace.visualstudio.com/items/Equinusocio.vsc-material-theme/changelog";
    description = "The most epic theme now for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme";
    homepage = "https://github.com/material-theme/vsc-material-theme";
    license = licenses.asl20;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
