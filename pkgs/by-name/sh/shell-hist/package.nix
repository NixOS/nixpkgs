{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "shell-hist";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jamesmunns";
    repo = "shell-hist";
    rev = "158de8c3908b49530ecd76bf6e65c210f351ef82";
    sha256 = "0kc128xnnp1d56if70vfv0w3qnwhljhbnvzwwb7hfm3x2m0vqrqf";
  };

  cargoHash = "sha256-V/smviEa7b+2vyY2dn9MpbITnXw0HpOtPF/RPYB2TKw=";

  meta = with lib; {
    description = "Inspect your shell history";
    homepage = "https://github.com/jamesmunns/shell-hist";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = [ maintainers.spacekookie ];
    mainProgram = "shell-hist";
  };
}
