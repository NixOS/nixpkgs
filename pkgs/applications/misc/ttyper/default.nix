{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5U6+16gy5s+1zDSxy6rMheZFAbpiya3uxvr21VaHDZQ=";
  };

  cargoHash = "sha256-O5fPV20OSEMv7Yw982ZorhN7y3NTzrprS79n2ID0LwU=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
