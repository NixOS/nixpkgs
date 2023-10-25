{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "kbt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-gZUZB7cbaYlDs3PfRhkRlyJ6FBqtUAANL/K8Q/Dk8Zc=";
  };

  cargoHash = "sha256-BcUxrZKJEgYgGQqgi9l6xcmwyTRNr9C2WWOgaFB5XSw=";

  meta = with lib; {
    description = "Keyboard tester in terminal";
    homepage = "https://github.com/bloznelis/kbt";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
