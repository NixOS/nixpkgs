{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "workstyle";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = "workstyle";
    rev = "8bde72d9a9dd67e0fc7c0545faca53df23ed3753";
    sha256 = "sha256-yhnt7edhgVy/cZ6FpF6AZWPoeMeEKTXP+87no2KeIYU=";
  };

  cargoHash = "sha256-es8kS1w71TuQ1pKb4/wXtpukWEBqUJUA+GX3uXOYbtU=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
    mainProgram = "workstyle";
  };
}
