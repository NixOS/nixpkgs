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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${version}";
    hash = "sha256-G3scFSOxbmR3Q2fkRdg115WN/GCYpys/8Y4JC4YMGdY=";
  };

  cargoHash = "sha256-EvXafTujqTdQwfK4NXgT7lGKGnrpyP9ouplD6DmJUKU=";

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
