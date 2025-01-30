{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  alejandra,
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    hash = "sha256-g0SSfTWZ5mtMOpQic+eqq9sXMy1E/7yKxxfupZd9V4A=";
  };

  cargoHash = "sha256-s3932c/k9UTbJ79fBQBRDILN2VWNM1tNEV7cW4fQK74=";

  passthru.tests = {
    version = testers.testVersion { package = alejandra; };
  };

  meta = with lib; {
    description = "Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [
      _0x4A6F
      kamadorueda
      sciencentistguy
    ];
    mainProgram = "alejandra";
  };
}
