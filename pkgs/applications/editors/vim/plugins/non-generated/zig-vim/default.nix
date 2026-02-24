{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2025-12-07";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig.vim";
    rev = "74bdb43c9d5da8d6b715809b79f92ef8f711df8e";
    hash = "sha256-RmrRgJ6YdExMwmua6nGv6W7DPP98k2URIaJTm+O4uR8=";
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
