{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "v${version}";
    hash = "sha256-tKSPk0V11pnKFV4E08H4CUnjw9nAonTRI6W3mGipd9I=";
  };

  cargoHash = "sha256-DiorrgTH9lIdmaZL7451uCXj9X7M6eHf4MQc85MpU7s=";

  meta = with lib; {
    description = "A blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [ zzzsy ];
    mainProgram = "lutgen";
    license = licenses.mit;
  };
}
