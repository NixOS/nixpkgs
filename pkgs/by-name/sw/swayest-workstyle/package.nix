{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  pname = "swayest-workstyle";
  version = "1.3.5";
  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    hash = "sha256-Dk6rAiz7PXUfyy9fWMtSVRjaWWl66n38gTNyWKqeqkU=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-sLQPq3tyWq1TxxeFyg05qBt+KGI/vO0jLU7wJLiqcYA=";

  # No tests
  doCheck = false;

  meta = {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = lib.licenses.mit;
    mainProgram = "sworkstyle";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
}
