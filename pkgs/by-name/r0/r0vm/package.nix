{ rustPlatform
, stdenv
, fetchFromGitHub
, fetchurl
, pkg-config
, perl
, openssl
, lib
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "r0vm";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "risc0";
    repo = "risc0";
    rev = "v${version}";
    sha256 = "sha256-0Y7+Z2TEm5ZbEkbO8nSOZulGuZAgl9FdyEVNmqV7S8U=";
  };

  buildAndTestSubdir = "risc0/r0vm";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl.dev
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  doCheck = false;

  cargoHash = "sha256-3DwrWkjPCE4f/FHjzWyRGAXJPv30B4Ce8fh2oKDhpMM=";

  postPatch =
    let
      # see https://github.com/risc0/risc0/blob/v1.0.1/risc0/circuit/recursion/build.rs
      sha256Hash = "4e8496469e1efa00efb3630d261abf345e6b2905fb64b4f3a297be88ebdf83d2";
      recursionZkr = fetchurl {
        name = "recursion_zkr.zip";
        url = "https://risc0-artifacts.s3.us-west-2.amazonaws.com/zkr/${sha256Hash}.zip";
        sha256 = "sha256-ToSWRp4e+gDvs2MNJhq/NF5rKQX7ZLTzope+iOvfg9I=";
      };
    in
    ''
      ln -sf ${recursionZkr} ./risc0/circuit/recursion/src/recursion_zkr.zip
    '';

  meta = with lib; {
    description = "RISC Zero zero-knowledge VM";
    homepage = "https://github.com/risc0/risc0";
    license = licenses.asl20;
    maintainers = with maintainers; [ marijanp ];
    mainProgram = "r0vm";
  };
}
