{
  apple-sdk_15,
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "jikken";
  version = "0.8.3-develop";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${version}";
    hash = "sha256-A3z7PfP0OpPbY0UJnqYDpRhh/wY1tM7wmI4Y6FRDSa4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XT2jmBuDySjYZJKU4vloghOsCa2kTfjPHX73VGHYSto=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Powerful, source control friendly REST API testing toolkit";
    homepage = "https://jikken.io/";
    changelog = "https://github.com/jikkenio/jikken/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "jk";
  };
}
