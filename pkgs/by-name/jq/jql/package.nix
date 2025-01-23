{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-acvLzxjj+HxVE/BWiWezeghDiP4VNNAzeFEs+u+b5iA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-O0WefEbtjBQp1JUV4lxPHN5aT+qo8mNxHsegSjVCgJU=";

  meta = with lib; {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
