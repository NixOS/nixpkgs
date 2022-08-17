{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zineland";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Pd/UAg6O9bOvrdvbY46Vf8cxFzjonEwcwPaaW59vH6E=";
  };

  cargoPatches = [ ./Cargo.lock.patch ]; # Repo does not provide Cargo.lock

  cargoSha256 = "sha256-qpzBDyNSZblmdimnnL4T/wS+6EXpduJ1U2+bfxM7piM=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
