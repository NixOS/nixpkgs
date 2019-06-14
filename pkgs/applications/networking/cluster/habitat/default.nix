{ lib, fetchFromGitHub, rustPlatform, pkgconfig
, libsodium, libarchive, openssl, zeromq }:

with rustPlatform;

buildRustPackage rec {
  name = "habitat-${version}";
  version = "0.82.0";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "00fq87kygvd6qmf9lclsblrr3c2m1gmfhpfxgzyzwyzgvh84m35k"; };

  cargoSha256 = "04a48drfx6cz4m51iffhr472jb5ar5yfd2588qm5pkhdkmvv6kx2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsodium libarchive openssl zeromq ];

  cargoBuildFlags = ["--package hab"];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test --package hab
    runHook postCheck
  '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    maintainers = [ maintainers.boj maintainers.rushmorem ];
    platforms = [ "x86_64-linux" ];
  };
}
