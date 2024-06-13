{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pv7GySqKD3G1eryq6YwVL159XuuWB8DmQ0d1fPuFcmc=";
  };

  cargoHash = "sha256-MKJCpSdf9MzpBmgWImYO5+uSVN9uTLaLl4khizVGoig=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
