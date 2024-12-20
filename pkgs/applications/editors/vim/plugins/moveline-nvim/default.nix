{
  lib,
  fetchFromGitHub,
  rustPlatform,
  vimUtils,
}:
let
  version = "2024-07-25";
  src = fetchFromGitHub {
    owner = "willothy";
    repo = "moveline.nvim";
    rev = "9f67f4b9e752a87eea8205f0279f261a16c733d8";
    hash = "sha256-B4t5+Q4Urx5bGm8glNpYkHhpp/rAhz+lDd2EpWFUYoY=";
  };
  moveline-lib = rustPlatform.buildRustPackage {
    inherit src version;
    pname = "moveline-lib";

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';

    cargoHash = "sha256-e9QB4Rfm+tFNrLAHN/nYUQ5PiTET8knQQIQkMH3UFkU=";
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
