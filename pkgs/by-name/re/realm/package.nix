{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "realm";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${version}";
    hash = "sha256-RcaFWR23FlMNuyTQ/7YbHm/k0AhkfsLX+qA10PW1Jfg=";
  };

  cargoHash = "sha256-BBZZNJYBW7hLYvIEzyTZtTKHlxF/7puFuRPJrmOjV/8=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
