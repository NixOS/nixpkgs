{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2026-01-24";

  src = fetchFromCodeberg {
    owner = "ziglang";
    repo = "zig.vim";
    rev = "2f53c35bee0d64a1d417d47c894a3cbb6663dff4";
    hash = "sha256-vrtcUAp/YWpZtf6lyg2l0GR62YdHprAb8sAHzZ89F48=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Vim configuration for Zig";
    homepage = "https://codeberg.org/ziglang/zig.vim/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
