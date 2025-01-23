{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZIPvdlE/oBmtdTpWm5GU53wGGYWCc74a9w5Kqpi8tBg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-D9HBJXn68jdY8ocSNUNNQHJy21H3z4KccyzTECTYYx0=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
