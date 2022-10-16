{ lib
, vscode-utils
}:
let
  version = "0.5.0";
in vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "vscode-squiggle";
    publisher = "QURI";
    inherit version;
    sha256 = "sha256-xkl6K2F3lc8bCds4pz/tHRiuAyk8l5HRfp9nxkUj/AI=";
  };

  meta = with lib; {
    description = "A simple programming language for intuitive probabilistic estimation";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=QURI.vscode-squiggle";
    homepage = "https://squiggle-language.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ quinn-dougherty ];
  };
}
