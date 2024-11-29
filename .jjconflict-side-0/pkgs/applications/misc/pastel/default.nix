{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kr2aLRd143ksVx42ZDO/NILydObinn3AwPCniXVVmY0=";
  };

  cargoHash = "sha256-+Cw/aAXkSbYLqc7TGWsMUJNo88v0s1Cq1m4V84j3gXE=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = with lib; {
    description = "Command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
    mainProgram = "pastel";
  };
}
