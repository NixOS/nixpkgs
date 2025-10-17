{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-new-workspace";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nzig";
    repo = "sway-new-workspace";
    rev = version;
    hash = "sha256-CoSfpsaGqNNR5jdAQys3nQxshI0NXXr8MacUnSTKFNo=";
  };

  cargoHash = "sha256-Gxqg0FqIU7e1oZ1inCe/xN3IXyQkMAt3yfbAfhfxy1o=";

  meta = with lib; {
    description = "Command to create new Sway workpaces";
    homepage = "https://github.com/nzig/sway-new-workspace";
    license = licenses.mit;
    mainProgram = "sway-new-workspace";
    maintainers = with maintainers; [ bbenno ];
    platforms = platforms.linux;
  };
}
