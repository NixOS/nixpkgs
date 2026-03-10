{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2026-02-27";

  src = fetchFromCodeberg {
    owner = "ziglang";
    repo = "zig.vim";
    rev = "366ef4855d22fd1377b81c382542466475b73a01";
    hash = "sha256-bo6/lvDx8JCttwTVw1eAImF/b5Aa0ekDN5H6WI0TAdo=";
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
