{
  lib,
  rustPlatform,
  fetchFromGitHub,
  robloxSupport ? true,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-QE9kXGQWg0pHtSI1bTppn5IE+53KoxqFED1VvwkumEI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7mAtTOnrNT8280TOAqtsykfdLq6XAQkDjR5JXZGwCFM=";

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs =
    lib.optionals robloxSupport [
      openssl
    ]
    ++ lib.optionals (robloxSupport && stdenv.hostPlatform.isDarwin) [
      darwin.apple_sdk.frameworks.Security
    ];

  buildNoDefaultFeatures = !robloxSupport;

  meta = with lib; {
    description = "Blazing-fast modern Lua linter written in Rust";
    mainProgram = "selene";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
