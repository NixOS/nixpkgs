{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    hash = "sha256-HbI2XPYNSFBc/h+kEsNsOxJ8+7uq1Ia0ce98FKoUlng=";
  };

  cargoHash = "sha256-zA5cTdW0x7k8/mAUfUBzbiBR1ypyeLr7AOyg+16Islk=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "nomino";
  };
}
