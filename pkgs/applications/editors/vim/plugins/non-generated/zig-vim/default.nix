{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "2025-11-15";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig.vim";
    rev = "1a1112eec20e28c832a06ddb1d0060f6ce652372";
    hash = "sha256-9SsDDVSFLu1RY3u8dlbcQWAKUe26L0Gc7mtyNY8v8H8=";
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
