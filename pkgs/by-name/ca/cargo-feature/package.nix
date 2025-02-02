{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UPpqkz/PwoMaJan9itfldjyTmZmiMb6PzCyu9Vtjj1s=";
  };

  cargoHash = "sha256-8qrpW/gU7BvxN3nSbFWhbgu5bwsdzYZTS3w3kcwsGbU=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = with lib; {
    description = "Cargo plugin to manage dependency features";
    mainProgram = "cargo-feature";
    homepage = "https://github.com/Riey/cargo-feature";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ riey matthiasbeyer ];
  };
}

