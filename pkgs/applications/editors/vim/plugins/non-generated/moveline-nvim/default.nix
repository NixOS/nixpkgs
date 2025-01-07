{
  lib,
  fetchFromGitHub,
  rustPlatform,
  vimUtils,
}:
let
  version = "0.3.1-unstable-2023-07-06";
  src = fetchFromGitHub {
    owner = "willothy";
    repo = "moveline.nvim";
    rev = "570603637be8af20e97b91cf554fef29cab73ca6";
    hash = "sha256-hq/n48JC1EgJbmb6b/1jQ8MNhbcsJD3wIYaKE1UiU30=";
  };
  moveline-lib = rustPlatform.buildRustPackage {
    inherit src version;
    pname = "moveline-lib";

    # Upstream doesn't contain a cargo lock
    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';
  };
in
vimUtils.buildVimPlugin {
  inherit src version;
  pname = "moveline-nvim";

  preInstall = ''
    mkdir -p lua
    ln -s ${moveline-lib}/lib/libmoveline.so lua/moveline.so
  '';

  nvimRequireCheck = "moveline";

  meta = {
    description = "Neovim plugin for moving lines up and down";
    homepage = "https://github.com/willothy/moveline.nvim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redxtech ];
    badPlatforms = [
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
