{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "doctave";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "doctave";
    repo = pname;
    rev = version;
    sha256 = "1780pqvnlbxxhm7rynnysqr0vihdkwmc6rmgp43bmj1k18ar4qgj";
  };

  # Cargo.lock is outdated
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "sha256-keLcNttdM9JUnn3qi/bWkcObIHl3MRACDHKPSZuScOc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Batteries-included developer documentation site generator";
    homepage = "https://github.com/doctave/doctave";
    changelog = "https://github.com/doctave/doctave/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "doctave";
  };
}
