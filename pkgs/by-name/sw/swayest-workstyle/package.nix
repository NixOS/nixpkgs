{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  pname = "swayest-workstyle";
  version = "1.3.6";
  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    hash = "sha256-0IFEVk6LQagwbm/QZG+dzYFfNhb7ieMxaCbFdeoZWwc=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-Txyj2o4Ew8VPKV/UCNiLhosgm5kuSl+na2l4H3yl/Yc=";

  # No tests
  doCheck = false;

  meta = {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = lib.licenses.mit;
    mainProgram = "sworkstyle";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
