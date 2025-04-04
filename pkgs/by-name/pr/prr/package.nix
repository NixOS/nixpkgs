{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  openssl,
  pkg-config,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "prr";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = "prr";
    rev = "v${version}";
    hash = "sha256-siQZ3rDKv2lnn1bmisRsexWwfvmMhK+z4GZGPsrfPgc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VIJFr1HpXMC2DXt79Yb1DuLYSbo9g6zsXaNDTXjtlR4=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Tool that brings mailing list style code reviews to Github PRs";
    homepage = "https://github.com/danobi/prr";
    license = licenses.gpl2Only;
    mainProgram = "prr";
    maintainers = with maintainers; [ evalexpr ];
  };
}
