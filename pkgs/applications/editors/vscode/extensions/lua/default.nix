{ lib
, vscode-utils
, lua-language-server
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lua";
    publisher = "sumneko";
    version = "3.5.6";
    sha256 = "sha256-Unzs9rX/0MlQprSvScdBCCFMeLCaGzWsMbcFqSKY2XY=";
  };

  patches = [ ./remove-chmod.patch ];

  postInstall = ''
    ln -sf ${lua-language-server}/bin/lua-language-server \
      $out/$installPrefix/server/bin/lua-language-server
  '';

  meta = with lib; {
    description = "The Lua language server provides various language features for Lua to make development easier and faster.";
    homepage = "https://marketplace.visualstudio.com/items?itemName=sumneko.lua";
    license = licenses.mit;
    maintainers = with maintainers; [ lblasc ];
  };
}
