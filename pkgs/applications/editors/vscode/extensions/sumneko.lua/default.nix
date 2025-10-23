{
  lib,
  vscode-utils,
  lua-language-server,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lua";
    publisher = "sumneko";
    version = "3.15.0";
    hash = "sha256-wcOo1gmWgPJJNQog2+emM05RE1fTtLqFANWfN3ExTnM=";
  };

  # Running chmod in runtime will lock up extension
  # indefinitely if the binary is in nix store.
  postPatch = ''
    substituteInPlace client/out/src/languageserver.js \
      --replace-fail 'await fs.promises.chmod(command, "777");' ""
  '';

  postInstall = ''
    ln -sf ${lua-language-server}/bin/lua-language-server \
      $out/$installPrefix/server/bin/lua-language-server
  '';

  meta = {
    description = "Lua language server provides various language features for Lua to make development easier and faster";
    homepage = "https://marketplace.visualstudio.com/items?itemName=sumneko.lua";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lblasc ];
  };
}
