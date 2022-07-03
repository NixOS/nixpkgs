{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "sha256-eyHFKAGx8du4osoGDsMFzVE/TC/ZMPsx6mrWUPDCLJ4=";
  };

  cargoSha256 = "sha256-/4+r5rvRUqQL8EVIg/22ZytXyE4+SV4UEcXiEw4795U=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
    mainProgram = "proton-call";
  };
}
