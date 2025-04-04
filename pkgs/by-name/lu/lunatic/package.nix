{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "lunatic";
  version = "0.13.2-unstable-2024-03-18";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = "lunatic";
    rev = "fc046ed65fecfdb580922c8df409881ca12b9052";
    hash = "sha256-hJ3A4KYubOY8/+1lBGQefwBWaCOJBprOCqK6CMJ6XW0=";
  };

  cargoPatches = [
    ./update-time-cargo-lock.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-+2koGrhM9VMLh8uO1YcaugcfmZaCP4S2twKem+y2oks=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  checkFlags = [
    # requires simd support which is not always available on hydra
    "--skip=state::tests::import_filter_signature_matches"
  ];

  meta = with lib; {
    description = "Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v0.13.2/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
