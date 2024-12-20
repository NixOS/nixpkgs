{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rotonda";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    rev = "v${version}";
    hash = "sha256-bhuVzoEgDrfj4z2rfD+2agkXKNLZXN/MA+AxmEaeuLk=";
  };

  cargoHash = "sha256-0i1dFMPNUAMgTdZ+f9fg0DvvhkpCmlPOjYoyFvHT4v4=";

  meta = with lib; {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/${src.rev}/Changelog.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
