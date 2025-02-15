{
  lib,
  rustPlatform,
  darwin,
  fetchCrate,
  pkg-config,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.26";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qwpUV+amv/n/lRcFYf/TgXoj3aHdg3kZJigEeA0fKBg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Lzuzb0d1p5JGrz1cp+GuB7uoCIV+xJLNs6N22Gd8Nbs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "star-history";
  };
}
