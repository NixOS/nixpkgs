{ lib
, rustPlatform
, fetchFromGitHub
}:
let
  version = "0.7.0";
in
rustPlatform.buildRustPackage {
  pname = "smag";
  inherit version;

  src = fetchFromGitHub {
    owner = "aantn";
    repo = "smag";
    rev = "v${version}";
    sha256 = "sha256-PdrK4kblXju23suMe3nYFT1KEbyQu4fwP/XTb2kV1fs=";
  };

  cargoHash = "sha256-SX6tOodmB0usM0laOt8mjIINPYbzHI4gyUhsR21Oqrw=";

  meta = with lib; {
    description = "Show Me A Graph - Command Line Graph Tool";
    homepage = "https://github.com/aantn/smag";
    changelog = "https://github.com/aantn/smag/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mightyiam ];
  };
}
