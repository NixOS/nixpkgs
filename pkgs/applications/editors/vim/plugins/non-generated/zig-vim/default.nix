{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2026-03-09";

  src = fetchFromCodeberg {
    owner = "ziglang";
    repo = "zig.vim";
    rev = "9e76c2843f6292dc9c804996d78244fe1028891a";
    hash = "sha256-eWQqr/LopjzFJhZC3mHdUrWVDcLPHDHkxcuhrJMaY3w=";
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
