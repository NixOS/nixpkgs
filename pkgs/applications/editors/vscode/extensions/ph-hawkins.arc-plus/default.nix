{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "arc-plus";
    publisher = "ph-hawkins";
    version = "1.0.2";
    hash = "sha256-kI8UHo16PbOSLXBG9du4Ceb+aorVGGOH17Vg6ufy/D0=";
  };
  meta = {
    description = "UI theme based on the Arc GTK theme while also retaining some elements of the default VS Code theme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ph-hawkins.arc-plus";
    homepage = "https://github.com/phil-harmoniq/arc-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
}
