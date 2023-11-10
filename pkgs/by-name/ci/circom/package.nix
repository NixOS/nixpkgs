{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "circom";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${version}";
    hash = "sha256-2YusBWAYDrTvFHYIjKpALphhmtsec7jjKHb1sc9lt3Q=";
  };

  cargoHash = "sha256-G6z+DxIhmm1Kzv8EQCqvfGAhQn5Vrx9LXrl+bWBVKaM=";
  doCheck = false;

  meta = with lib; {
    description = "zkSnark circuit compiler";
    homepage = "https://github.com/iden3/circom";
    changelog = "https://github.com/iden3/circom/blob/${src.rev}/RELEASES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
