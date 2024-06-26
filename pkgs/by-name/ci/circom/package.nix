{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "circom";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${version}";
    hash = "sha256-l8204koaKTluYEvk6j9+MokdOqFCq2oExT5P2aW3kzc=";
  };

  cargoHash = "sha256-M4FR/dPLIq1Ps0j1B69khmSl4uRE5wxN4dh3iuO/9A4=";
  doCheck = false;

  meta = with lib; {
    description = "zkSnark circuit compiler";
    mainProgram = "circom";
    homepage = "https://github.com/iden3/circom";
    changelog = "https://github.com/iden3/circom/blob/${src.rev}/RELEASES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
