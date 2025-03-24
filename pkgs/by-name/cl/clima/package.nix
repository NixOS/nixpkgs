{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "clima";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "clima";
    rev = "v${version}";
    hash = "sha256-CRnAxhkuCTyHR4uQofA51Dm3+YKqm3iwBkFNkbLTv1A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3BNDo5ksra1d8X6yQZYSlS2CSiZfkuTHkQtIC2ckbKE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Minimal viewer for Termimad";
    homepage = "https://github.com/Canop/clima";
    changelog = "https://github.com/Canop/clima/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "clima";
  };
}
