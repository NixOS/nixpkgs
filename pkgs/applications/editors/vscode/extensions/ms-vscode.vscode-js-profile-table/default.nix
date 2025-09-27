{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-js-profile-table";
    publisher = "ms-vscode";
    version = "1.0.10";
    sha256 = "sha256-c2F0jd+f0J2KLtHyotc3aiz5qucIaSggt5lwg4XDjgg=";
  };

  meta = {
    description = "Text visualizer for profiles taken from the JavaScript debugger";
    homepage = "https://github.com/microsoft/vscode-js-profile-visualizer";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-js-profile-table";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
