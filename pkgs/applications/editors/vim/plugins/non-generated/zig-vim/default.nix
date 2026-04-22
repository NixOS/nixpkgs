{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2026-04-13";

  src = fetchFromCodeberg {
    owner = "ziglang";
    repo = "zig.vim";
    rev = "30a1634b3a4193290dc3aad8f84c53b353b1d80f";
    hash = "sha256-2nr6csxVNDI/fRf0bsYcFKHWhvJe0vMkOT/J+4+EJaU=";
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
