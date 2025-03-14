{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "circom";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${version}";
    hash = "sha256-Vwu2DAWIqzqgo6oXcQxvhn7ssGojQkRRw9sKk7qjREk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-64mKd3M5EpqWASTPz7cqNbDyh4be7xR4fudjcx029u8=";
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
