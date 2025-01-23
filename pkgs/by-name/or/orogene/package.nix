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
  pname = "orogene";
  version = "0.3.34";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-GMWrlvZZ2xlcvcRG3u8jS8KiewHpyX0brNe4pmCpHbM=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ju3nRevwJZfnoSqEIERkfMyg6Dy8ky53qf1ZXuAOjsw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  preCheck = ''
    export CI=true
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Package manager for tools that use node_modules";
    homepage = "https://github.com/orogene/orogene";
    changelog = "https://github.com/orogene/orogene/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      isc
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oro";
  };
}
