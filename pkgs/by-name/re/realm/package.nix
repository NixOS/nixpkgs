{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "realm";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${version}";
    hash = "sha256-vkLGfSDRYqvoqyVM/CWGJjpvXXPisEZxUSjLZGjNzno=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Oe64l16uYdU6NvTl7XrEm6dAtRFngI9yHC4fe4hpTNA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env.RUSTC_BOOTSTRAP = 1;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) realm; };
  };

  meta = with lib; {
    description = "A simple, high performance relay server written in rust";
    homepage = "https://github.com/zhboner/realm";
    mainProgram = "realm";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox ];
  };
}
