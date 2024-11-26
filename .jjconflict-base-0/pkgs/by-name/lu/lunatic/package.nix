{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uMMssZaPDZn3bOtQIho+GvUCPmzRllv7eJ+SJuKaYtg=";
  };

  cargoHash = "sha256-ALjlQsxmZVREyi3ZGMJMv/38kkMjYh+hTSr/0avYJVs=";

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
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
