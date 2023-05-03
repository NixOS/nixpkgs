{ lib
, vscode-utils
, lua-language-server
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lua";
    publisher = "sumneko";
    version = "3.6.19";
    sha256 = "sha256-7f8zovJS1lNwrUryxgadrBbNRw/OwFqry57JWKY1D8E=";
  };

  # Running chmod in runtime will lock up extension
  # indefinitely if the binary is in nix store.
  patches = [ ./remove-chmod.patch ];

  postInstall = ''
    ln -sf ${lua-language-server}/bin/lua-language-server \
      $out/$installPrefix/server/bin/lua-language-server
  '';

  meta = {
    description = "The Lua language server provides various language features for Lua to make development easier and faster.";
    homepage = "https://marketplace.visualstudio.com/items?itemName=sumneko.lua";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lblasc ];
  };
}
